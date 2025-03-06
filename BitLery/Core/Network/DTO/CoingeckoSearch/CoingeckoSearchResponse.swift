//
//  CoingeckoSearchResponse.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct CoingeckoSearchResponse: Decodable {
    struct CoinResponse: Decodable {
        let id: String // 코인 ID
        let name: String // 코인 이름
        let symbol: String // 코인 통화 단위
        let marketCapRank: Int // 시가 총액 랭킹
        let thumb: String // 코인 아이콘 리소스
        let large: String // 코인 아이콘 리소스
    }
    
    let coins: [CoinResponse]
}
