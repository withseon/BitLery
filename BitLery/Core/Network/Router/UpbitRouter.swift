//
//  UpbitRouter.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum UpbitRouter {
    case ticker(dto: UpbitTickerRequest)
}

extension UpbitRouter: RequestType {
    var baseURL: URL {
        switch self {
        case .ticker:
            return URL(string: APIURL.UPBIT_TICKER)!
        }
    }
    
    var method: Method {
        return .get
    }
    
    var parameter: [String : Any] {
        switch self {
        case .ticker(let dto):
            return dto.toDictionary
        }
    }
    
    var header: [String : String] {
        return ["accept": "application/json"]
    }
}
