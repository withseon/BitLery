//
//  CoingeckoTrendResponse.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct CoingeckoTrendResponse: Decodable {
    struct ItemResponse: Decodable {
        struct CoinResponse: Decodable {
            struct DataResponse: Decodable {
                struct PriceChangeResponse: Decodable {
                    let krw: Double // 24시간 동안 코인 변동폭
                }
                
                let price: Double // 코인 현재가
                let priceChangePercentage24H: PriceChangeResponse
            }
            
            let id: String // 코인 ID
            let coinId: Int // 코인 ID
            let name: String // 코인 이름
            let symbol: String // 코인 통화 단위
            let thumb: String // 코인 아이콘 리소스
            let small: String
            let large: String
            let data: DataResponse
        }
        
        let item: CoinResponse
    }
    
    struct NFTResponse: Decodable {
        struct DataResponse: Decodable {
            let floorPrice: String // 24시간 중 NFT 최저가
        }
        
        let name: String // NFT 토큰명
        let thumb: String // NFT 아이콘 리소스
        let floorPrice24HPercentageChange: Double // 24시간 동안 NFT 변동폭
        let data: DataResponse
    }
    
    let coins: [ItemResponse]
    let nfts: [NFTResponse]
}

extension CoingeckoTrendResponse.ItemResponse {
    var asTrendCoins: TrendCoin {
        return TrendCoin(id: item.id,
                         name: item.name,
                         symbol: item.symbol,
                         thumbImage: item.thumb,
                         changedRatePrice: item.data.priceChangePercentage24H.krw)
    }
}

extension CoingeckoTrendResponse.NFTResponse {
    var asTrendNFTs: TrendNFT {
        return TrendNFT(name: name,
                        thumbImage: thumb,
                        changedRatePrice: floorPrice24HPercentageChange,
                        floorPrice: data.floorPrice)
    }
}
