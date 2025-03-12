//
//  CoingeckoMarketResponse.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct CoingeckoMarketResponse: Decodable {
    struct SparklineResponse: Decodable {
        let price: [Double]
    }
    
    let id: String // 코인 ID
    let symbol: String // 코인 통화 단위
    let name: String // 코인 이름
    let image: String // 코인 아이콘 리소스
    let currentPrice: Double // 코인 현재가
    let priceChangePercentage24H: Double // 코인 변동폭
    let lastUpdated: String // 최근 업데이트 시간
    let low24H: Double // 코인 24시간 저가
    let high24H: Double // 코인 24시간 고가
    let ath: Double // 코인 사상 최고가(신고점, All-Time High)
    let athDate: String // 신고점 일자
    let atl: Double // 코인 사상 최저가(신저점, All-Time Low)
    let atlDate: String // 선저점 일자
    let marketCap: Int // 시가 총액
    let fullyDilutedValuation: Int // 완전 희석 가치
    let totalVolume: Double // 총 거래량
    let sparklineIn7D: SparklineResponse // 일주일 간 코인 시세 정보
}

extension CoingeckoMarketResponse {
    var asCoinMarket: CoinMarket {
        return CoinMarket(id: id,
                          currentPrice: FormatHelper.shared.krwPrice(currentPrice),
                          changeRatePrice: priceChangePercentage24H,
                          lastUpdate: FormatHelper.shared.marketUpdateTime(lastUpdated),
                          lowPrice24H: FormatHelper.shared.krwPrice(low24H),
                          highPrice24H: FormatHelper.shared.krwPrice(high24H),
                          atHighPrice: FormatHelper.shared.krwPrice(ath),
                          atHighDate: FormatHelper.shared.priceUpdateTime(athDate),
                          atLowPrice: FormatHelper.shared.krwPrice(atl),
                          atLowDate: FormatHelper.shared.priceUpdateTime(atlDate),
                          marketCapPrice: marketCap.formatted(.currency(code: "krw")),
                          fullyDilutedValuation: fullyDilutedValuation.formatted(.currency(code: "krw")),
                          totalVolume: totalVolume.formatted(.currency(code: "krw")),
                          sparklinePrices: sparklineIn7D.price)
    }
}
