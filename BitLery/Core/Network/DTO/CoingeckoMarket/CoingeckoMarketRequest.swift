//
//  CoingeckoMarketRequest.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct CoingeckoMarketRequest: Requestable {
    let vsCurrency: String
    let ids: String
    let sparkline: String
    
    init(vsCurrency: String = "krw", ids: String, sparkline: Bool = true) {
        self.vsCurrency = vsCurrency
        self.ids = ids
        self.sparkline = String(describing: sparkline)
    }
}
