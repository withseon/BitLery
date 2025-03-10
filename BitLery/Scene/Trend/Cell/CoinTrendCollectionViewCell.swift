//
//  CoinTrendCollectionViewCell.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import SnapKit

final class CoinTrendCollectionViewCell: BaseCollectionViewCell {
    private let rankLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let nameStackView = UIStackView()
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let rateView = RateView()
    
    override func configureHierarchy() {
        [rankLabel, thumbnailImageView, nameStackView, rateView].forEach { view in
            contentView.addSubview(view)
        }
        nameStackView.addArrangedSubview(symbolLabel)
        nameStackView.addArrangedSubview(nameLabel)
    }
    
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }
        nameStackView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        rateView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(nameStackView.snp.trailing).offset(8)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        rankLabel.font = Resource.SystemFont.regular12
        rankLabel.textColor = .labelMain
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 13
        
        nameStackView.axis = .vertical
        symbolLabel.font = Resource.SystemFont.bold12
        symbolLabel.textColor = .labelMain
        symbolLabel.textAlignment = .left
        nameLabel.font = Resource.SystemFont.regular9
        nameLabel.textColor = .labelSecondary
    }
}

extension CoinTrendCollectionViewCell {
    func setContent(rank: String, coin: TrendCoin) {
        rankLabel.text = rank
        thumbnailImageView.setKFImage(strURL: coin.thumbImage)
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        rateView.setContent(coin.changedRatePrice)
    }
}
