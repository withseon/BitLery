//
//  UpbitTickerRequest.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct UpbitTickerRequest: Requestable {
    let quoteCurrencies: String
    
    init(quoteCurrencies: String = "KRW") {
        self.quoteCurrencies = quoteCurrencies
    }
}

