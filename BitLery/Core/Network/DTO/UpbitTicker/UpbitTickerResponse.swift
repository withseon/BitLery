//
//  UpbitTickerResponse.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

struct UpbitTickerResponse: Decodable {
    let market: String // 종목 구분 코드
    let tradePrice: Double // 종가(현재가)
    let change: String // EVEN : 보합, RISE : 상승, FALL : 하락
    let signedChangeRate: Double // 부호가 있는 변화율
    let signedChangePrice: Double // 부호가 있는 변화액
    let accTradePrice24H: Double // 24시간 누적 거래대금
}
