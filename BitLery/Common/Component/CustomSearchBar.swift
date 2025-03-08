//
//  CustomSearchBar.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import SnapKit

final class CustomSearchBar: BaseView {
    private let imageView = UIImageView()
    let textField = UITextField()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(textField)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    override func configureView() {
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.labelSecondary.cgColor
        
        let config = UIImage.SymbolConfiguration(font: Resource.SystemFont.bold12)
        imageView.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        imageView.tintColor = .labelSecondary
        imageView.contentMode = .scaleAspectFill
        
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.",
                                                             attributes: [.foregroundColor: UIColor.labelSecondary])
        textField.font = Resource.SystemFont.regular14
        textField.textColor = .labelMain
        textField.tintColor = .labelMain
        textField.clearButtonMode = .always
        textField.returnKeyType = .search
    }
}
