//
//  CoingeckoError.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum CoingeckoError: Error {
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case tooManyRequest // 429
    case serverError // 500
    case serviceUnavailable // 503
    case accessDenied // 1020
    case apiKeyMissing // 10002
    case limitProAPI // 10005
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 429: self = .tooManyRequest
        case 500: self = .serverError
        case 503: self = .serviceUnavailable
        case 1020: self = .accessDenied
        case 10002: self = .apiKeyMissing
        case 10005: self = .limitProAPI
        default: self = .unknown
        }
    }
    
    var message: String {
        switch self {
        case .badRequest: return "잘못된 요청입니다."
        case .unauthorized: return "인증에 실패했습니다."
        case .forbidden: return "접근이 차단되었습니다."
        case .tooManyRequest: return "요청 횟수를 초과했습니다."
        case .serverError: return "서버에 오류가 발생했습니다."
        case .serviceUnavailable: return "현재 서비스를 이용할 수 없습니다."
        case .accessDenied: return "방화벽 규칙이 위반되었습니다."
        case .apiKeyMissing: return "잘못된 API키입니다."
        case .limitProAPI: return "Pro API 서비스입니다."
        case .unknown: return "알 수 없는 오류입니다."
        }
    }
}
