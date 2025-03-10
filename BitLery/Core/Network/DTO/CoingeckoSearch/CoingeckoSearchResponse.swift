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
        
        enum CodingKeys: CodingKey {
            case id
            case name
            case symbol
            case marketCapRank
            case thumb
            case large
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CoingeckoSearchResponse.CoinResponse.CodingKeys> = try decoder.container(keyedBy: CoingeckoSearchResponse.CoinResponse.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.id)
            self.name = try container.decode(String.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.name)
            self.symbol = try container.decode(String.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.symbol)
            self.marketCapRank = try container.decodeIfPresent(Int.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.marketCapRank) ?? -1
            self.thumb = try container.decode(String.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.thumb)
            self.large = try container.decode(String.self, forKey: CoingeckoSearchResponse.CoinResponse.CodingKeys.large)
        }
    }
    
    let coins: [CoinResponse]
}

extension CoingeckoSearchResponse.CoinResponse {
    var asSearchCoin: SearchCoin {
        return SearchCoin(id: id,
                          name: name,
                          symbol: symbol,
                          rank: marketCapRank,
                          thumbnailImage: thumb,
                          largeImage: large)
    }
}
