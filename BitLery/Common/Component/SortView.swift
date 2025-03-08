//
//  SortView.swift
//  BitLery
//
//  Created by 정인선 on 3/7/25.
//

import UIKit
import SnapKit

final class SortView: BaseView {
    private let titleLabel = UILabel()
    private let upImage = UIImageView()
    private let downImage = UIImageView()
    
    init(_ text: String) {
        titleLabel.text = text
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [titleLabel, upImage, downImage].forEach { view in
            addSubview(view)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        upImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
        downImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.bottom.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.font = Resource.SystemFont.bold12
        titleLabel.textColor = .labelMain
        titleLabel.textAlignment = .right
        
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 6.5))
        upImage.image = UIImage(systemName: "arrowtriangle.up.fill", withConfiguration: config)
        downImage.image = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: config)
        
        setDefault()
    }
}

extension SortView {
    func setAsc() {
        upImage.tintColor = .labelMain
        downImage.tintColor = .labelSecondary
    }
    
    func setDesc() {
        upImage.tintColor = .labelSecondary
        downImage.tintColor = .labelMain
    }
    
    func setDefault() {
        upImage.tintColor = .labelSecondary
        downImage.tintColor = .labelSecondary
    }
}
