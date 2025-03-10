//
//  DetailInfoView.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import UIKit
import SnapKit

final class DetailInfoView: BaseView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let dateLabel = UILabel()
    
    init(_ title: String) {
        titleLabel.text = title
        dateLabel.isHidden = true
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        addSubview(stackView)
        [titleLabel, priceLabel, dateLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        stackView.axis = .vertical
        titleLabel.font = Resource.SystemFont.regular12
        titleLabel.textColor = .labelSecondary
        titleLabel.textAlignment = .left
        priceLabel.font = Resource.SystemFont.bold12
        priceLabel.textColor = .labelMain
        priceLabel.textAlignment = .left
        dateLabel.font = Resource.SystemFont.regular9
        dateLabel.textColor = .labelSecondary
        dateLabel.textAlignment = .left
    }
}

extension DetailInfoView {
    func setContent(price: String, date: String? = nil) {
        priceLabel.text = price
        if let date {
            dateLabel.text = date
            dateLabel.isHidden = false
        }
    }
}
