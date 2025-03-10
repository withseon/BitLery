//
//  MarketCoin.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import Foundation

struct CoinMarket {
    let id: String
    let currentPrice: String
    let changeRatePrice: Double
    let lastUpdate: String
    let lowPrice24H: String
    let highPrice24H: String
    let atHighPrice: String
    let atHighDate: String
    let atLowPrice: String
    let atLowDate: String
    let marketCapPrice: String
    let fullyDilutedValuation: String
    let totalVolume: String
    let sparklinePrices: [Double]
}
