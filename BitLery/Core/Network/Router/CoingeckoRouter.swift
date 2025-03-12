//
//  CoingeckoRouter.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum CoingeckoRouter {
    case market(dto: CoingeckoMarketRequest)
    case trend
    case search(dto: CoingeckoSearchRequest)
}

extension CoingeckoRouter: RequestType {
    var baseURL: URL {
        switch self {
        case .market:
            return URL(string: APIURL.COINGECKO_MARKET)!
        case .trend:
            return URL(string: APIURL.COINGECKO_TREND)!
        case .search:
            return URL(string: APIURL.COINGECKO_SEARCH)!
        }
    }
    
    var method: Method {
        return .get
    }
    
    var parameter: [String : Any] {
        switch self {
        case .market(let dto):
            return dto.toDictionary
        case .trend:
            return [:]
        case .search(let dto):
            return dto.toDictionary
        }
    }
    
    var header: [String : String] {
        return ["accept": "application/json"]
    }
}
