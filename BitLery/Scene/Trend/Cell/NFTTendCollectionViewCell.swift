//
//  NFTTendCollectionViewCell.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import SnapKit

final class NFTTrendCollectionViewCell: BaseCollectionViewCell {
    private let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let rateView = RateView()
    
    override func configureHierarchy() {
        [thumbnailImageView, nameLabel, priceLabel, rateView].forEach { view in
            contentView.addSubview(view)
        }
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(72)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(thumbnailImageView).inset(6)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.horizontalEdges.equalTo(thumbnailImageView).inset(6)
        }
        rateView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 24
        
        nameLabel.font = Resource.SystemFont.bold9
        nameLabel.textColor = .labelMain
        nameLabel.textAlignment = .center
        priceLabel.font = Resource.SystemFont.regular9
        priceLabel.textColor = .labelSecondary
        priceLabel.textAlignment = .center
    }
}

extension NFTTrendCollectionViewCell {
    func setContent(nft: TrendNFT) {
        thumbnailImageView.setKFImage(strURL: nft.thumbImage)
        nameLabel.text = nft.name
        priceLabel.text = nft.floorPrice
        rateView.setContent(nft.changedRatePrice)
    }
}
