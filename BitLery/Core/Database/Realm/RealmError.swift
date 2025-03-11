//
//  RealmError.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import Foundation

enum RealmError: Error {
    case save
    case append
    case delete
    
    var message: String {
        switch self {
        case .save: return "realm save fail"
        case .append: return "realm append fail"
        case .delete: return "realm append fail"
        }
    }
}
