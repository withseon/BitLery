//
//  NetworkError.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum NetworkError: Error {
    case transport(_ error: Error)
    case serverData(data: Data, statusCode: Int)
    case missingData
    case decoding(_ error: Error)
    
    var message: String {
        switch self {
        case .transport:
            return "Network Error:: 오류 발생"
        case .serverData( _, let statusCode):
            return "Network Error:: API 오류 StatusCode -\(statusCode)"
        case .missingData:
            return "Network Error:: 데이터 없음"
        case .decoding:
            return "Network Error:: 디코딩 실패"
        }
    }
    
    var debugMessage: String {
        switch self {
        case .transport(let error):
            return "❌ Network Error:: Transport - \(error)"
        case .serverData(_, let statusCode):
            return "❌ Network Error:: serverData - \(statusCode)"
        case .missingData:
            return "❌ Network Error:: MissingData"
        case .decoding(let error):
            return "❌ Network Error:: Decoding - \(error)"
        }
    }
}
