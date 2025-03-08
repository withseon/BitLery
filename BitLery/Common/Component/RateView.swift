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
    
    init() {
        changeImageView.isHidden = true
        super.init(frame: .zero)
    }
    
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
    func setContent(text: String, change: RateChange) {
        rateLabel.text = text
        rateLabel.font = Resource.SystemFont.bold9
        rateLabel.textColor = change.color
        
        changeImageView.tintColor = change.color
        switch change {
        case .even:
            break
        case .rise:
            changeImageView.isHidden = false
            changeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        case .fall:
            changeImageView.isHidden = false
            changeImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
}
