//
//  TrendCoin.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation

struct TrendCoin {
    let id: String
    let name: String
    let symbol: String
    let thumbImage: String
    let changedRatePrice: Double
}

extension TrendCoin {
    var asCoinBasicInfo: CoinBasicInfo {
        return CoinBasicInfo(id: id,
                             name: name,
                             symbol: symbol,
                             thumbImage: thumbImage)
    }
}
