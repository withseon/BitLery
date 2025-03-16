//
//  SearchCoinCollectionViewCell.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SearchCoinCollectionViewCell: BaseCollectionViewCell {
    private let thumbnailImageView = UIImageView()
    private let nameView = UIView()
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let rankBackgroundView = UIView()
    private let rankLabel = UILabel()
    private let starImageView = UIImageView()
    let starButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [thumbnailImageView, nameView, rankBackgroundView, rankLabel, starImageView, starButton].forEach { view in
            contentView.addSubview(view)
        }
        nameView.addSubview(symbolLabel)
        nameView.addSubview(nameLabel)
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(36)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        nameView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        symbolLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        rankBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel.snp.trailing).offset(4)
            make.centerY.equalTo(symbolLabel)
        }
        rankLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(rankBackgroundView).inset(4)
            make.verticalEdges.equalTo(rankBackgroundView).inset(1)
        }
        starImageView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(rankBackgroundView.snp.trailing).offset(20)
            make.leading.greaterThanOrEqualTo(nameView.snp.trailing).offset(20)
            make.size.equalTo(20)
            make.trailing.centerY.equalToSuperview().inset(20)
        }
        starButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(starButton.snp.height)
            make.centerX.equalTo(starImageView)
        }
    }
    
    override func configureView() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 18
        
        symbolLabel.font = Resource.SystemFont.bold14
        symbolLabel.textColor = .labelMain
        symbolLabel.textAlignment = .left
        nameLabel.font = Resource.SystemFont.regular12
        nameLabel.textColor = .labelSecondary
        nameLabel.textAlignment = .left
        
        rankBackgroundView.backgroundColor = .backgroundSecondary
        rankBackgroundView.clipsToBounds = true
        rankBackgroundView.layer.cornerRadius = 4
        rankLabel.font = Resource.SystemFont.bold9
        rankLabel.textColor = .labelSecondary
        
        starImageView.contentMode = .scaleAspectFill
        starImageView.tintColor = .labelMain
    }
}

extension SearchCoinCollectionViewCell {
    func setContent(_ searchCoin: SearchCoin) {
        thumbnailImageView.setKFImage(strURL: searchCoin.largeImage)
        symbolLabel.text = searchCoin.symbol
        nameLabel.text = searchCoin.name
        rankLabel.text = "#\(searchCoin.rank)"
        rankBackgroundView.isHidden = searchCoin.rank < 1
        rankLabel.isHidden = searchCoin.rank < 1
        changeStarImage(searchCoin.isLiked)
    }
    
    func changeStarImage(_ isLiked: Bool) {
        if isLiked {
            starImageView.image = UIImage(named: "star_fill")
        } else {
            starImageView.image = UIImage(named: "star")
        }
    }
}
