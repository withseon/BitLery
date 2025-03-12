//
//  RateView.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import SnapKit

final class RateView: BaseView {
    private let changeImageView = UIImageView()
    private let rateLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(changeImageView)
        addSubview(rateLabel)
    }
    
    override func configureLayout() {
        changeImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(9)
        }
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(changeImageView.snp.trailing).offset(1)
            make.trailing.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        changeImageView.contentMode = .scaleAspectFill
        rateLabel.font = Resource.SystemFont.bold9
    }
}

extension RateView {
    func setContent(_ rate: Double) {
        rateLabel.text = FormatHelper.shared.changeAbsRate(rate)
        rateLabel.font = Resource.SystemFont.bold9
        
        let rateResource = Resource.getRateResource(rate)
        rateLabel.textColor = rateResource.color
        changeImageView.tintColor = rateResource.color
        changeImageView.image = rateResource.image
    }
}
