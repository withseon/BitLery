//
//  FormatManager.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation

final class FormatManager {
    static let shared = FormatManager()
    private let isoDateFormatter = ISO8601DateFormatter()
    private let dateFormatter = DateFormatter()
    
    private init() {
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    }
}

extension FormatManager {
    func marketName(_ text: String) -> String {
        let names = text.components(separatedBy: "-")
        return "\(names[1])/\(names[0])"
    }
    
    func changeRate(_ num: Double) -> String {
        return String(format: "%.2f%%", ((num * 100).rounded() / 100))
    }
    
    func changeAbsRate(_ num: Double) -> String {
        return String(format: "%.2f%%", abs((num * 100).rounded() / 100))
    }
    
    func changePrice(_ num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1.0) == 0  {
            return "\(num.formatted())"
        } else {
            let num = (num * 100).rounded() / 100
            return String(format: "%.2f", num)
        }
    }
    
    func tradePrice(_ num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1.0) == 0  {
            return num.formatted()
        } else {
            let num = (num * 100).rounded() / 100
            return String(num)
        }
    }
    
    func accPrice(_ num: Double) -> String {
        let num = Int(num)
        if num >= 1000000 {
            return "\((num / 1000000).formatted())백만"
        } else {
            return num.formatted()
        }
    }
    
    func krwPrice(_ num: Double) -> String {
        let num = (num * 100).rounded() / 100
        if num.truncatingRemainder(dividingBy: 1.0) == 0  {
            return "\(num.formatted(.currency(code: "krw")))"
        } else {
            return String(format: "₩%.2f", num)
        }
    }
    
    func trendUpdateTime(_ date: Date) -> String {
        dateFormatter.dateFormat = "MM.dd hh:mm 기준"
        return dateFormatter.string(from: date)
    }
    
    func marketUpdateTime(_ text: String) -> String {
        guard let date = isoDateFormatter.date(from: text) else { return "" }
        dateFormatter.dateFormat = "M/d hh:mm:ss 업데이트"
        return dateFormatter.string(from: date)
    }
    
    func priceUpdateTime(_ text: String) -> String {
        guard let date = isoDateFormatter.date(from: text) else { return "" }
        dateFormatter.dateFormat = "yy년 M월 d일"
        return dateFormatter.string(from: date)
    }
}
