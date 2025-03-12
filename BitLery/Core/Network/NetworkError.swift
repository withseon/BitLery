//
//  NetworkError.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum NetworkError: Error {
    case lostNetwork(_ error: Error)
    case transport(_ error: Error)
    case server(error: APIErrorResponse, statusCode: Int)
    case decodingServer(error: Error, statusCode: Int)
    case missingData
    case decoding(_ error: Error)
    
    var message: String {
        switch self {
        case .lostNetwork:
            return "Network Error:: 네트워크 없음"
        case .transport:
            return "Network Error:: 오류 발생"
        case .server(let error, let statusCode):
            return "Network Error:: \(error.errorMessage) (StatusCode: \(statusCode))"
        case .decodingServer(statusCode: let statusCode):
            return "Network Error:: 상태 코드 - \(statusCode)"
        case .missingData:
            return "Network Error:: 데이터 없음"
        case .decoding:
            return "Network Error:: 디코딩 실패"
        }
    }
    
    var debugMessage: String {
        switch self {
        case .lostNetwork(let error):
            return "❌ Network Error:: Transport - \(error)"
        case .transport(let error):
            return "❌ Network Error:: Transport - \(error)"
        case .server(let error, let statusCode):
            return "❌ Network Error:: serverError(statusCode: \(statusCode) - \(error)"
        case .decodingServer(let error, let statusCode):
            return "❌ Network Error:: decodingServer(statusCode: \(statusCode) - \(error)"
        case .missingData:
            return "❌ Network Error:: MissingData"
        case .decoding(let error):
            return "❌ Network Error:: Decoding - \(error)"
        }
    }
}
