//
//  MarketSearchViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import UIKit
import SnapKit

final class MarketSearchViewController: BaseViewController {
    private let mainLabel = UILabel()
    
    override func configureHierarchy() {
        view.addSubview(mainLabel)
    }
    
    override func configureLayout() {
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        mainLabel.text = "서비스 준비중입니다"
        mainLabel.font = Resource.SystemFont.regular12
        mainLabel.textColor = .labelSecondary
    }
}
