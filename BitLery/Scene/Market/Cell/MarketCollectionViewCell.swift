//
//  MarketCollectionViewCell.swift
//  BitLery
//
//  Created by 정인선 on 3/7/25.
//

import UIKit
import SnapKit

final class MarketCollectionViewCell: BaseCollectionViewCell {
    private let nameLabel = UILabel()
    private let tradePriceLabel = UILabel()
    private let changedRateLabel = UILabel()
    private let changedPriceLabel = UILabel()
    private let accPriceLabel = UILabel()
    
    private let formatManager = FormatManager.shared
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        tradePriceLabel.text = nil
        changedRateLabel.text = nil
        changedPriceLabel.text = nil
        accPriceLabel.text = nil
    }
    
    override func configureHierarchy() {
        [nameLabel, tradePriceLabel, changedRateLabel, changedPriceLabel, accPriceLabel].forEach { view in
            contentView.addSubview(view)
        }
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        tradePriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing)
            make.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        changedRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(tradePriceLabel.snp.trailing)
            make.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        changedPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(changedRateLabel.snp.bottom)
            make.trailing.equalTo(changedRateLabel)
            make.width.equalTo(changedRateLabel)
            make.bottom.equalToSuperview().inset(8)
        }
        accPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(changedRateLabel.snp.trailing)
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        nameLabel.font = Resource.SystemFont.bold12
        nameLabel.textColor = .labelMain
        nameLabel.textAlignment = .left
        
        tradePriceLabel.font = Resource.SystemFont.regular12
        tradePriceLabel.textColor = .labelMain
        tradePriceLabel.textAlignment = .right
        
        changedRateLabel.font = Resource.SystemFont.regular12
        changedRateLabel.textAlignment = .right
        
        changedPriceLabel.font = Resource.SystemFont.regular9
        changedPriceLabel.textAlignment = .right
        
        accPriceLabel.font = Resource.SystemFont.regular12
        accPriceLabel.textColor = .labelMain
        accPriceLabel.textAlignment = .right
    }
}

extension MarketCollectionViewCell {
    func setContent(_ ticker: Ticker) {
        nameLabel.text = ticker.market
        tradePriceLabel.text = formatManager.tradePrice(ticker.tradePrice)
        changedRateLabel.text = formatManager.changeRate(ticker.changedRate)
        changedPriceLabel.text = formatManager.changePrice(ticker.changedPrice)
        accPriceLabel.text = formatManager.accPrice(ticker.accTradePrice)
        
        changedRateLabel.textColor = Resource.getRateResource(ticker.changedRate).color
        changedPriceLabel.textColor = Resource.getRateResource(ticker.changedPrice).color
    }
}
