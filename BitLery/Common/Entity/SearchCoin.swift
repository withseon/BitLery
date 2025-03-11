//
//  SearchCoin.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation

struct SearchCoin {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let thumbnailImage: String
    let largeImage: String
    var isLiked: Bool = false
}

extension SearchCoin {
    var asCoinBasicInfo: CoinBasicInfo {
        return CoinBasicInfo(id: id,
                             name: name,
                             symbol: symbol,
                             thumbImage: thumbnailImage)
    }
}
