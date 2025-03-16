//
//  CustomNavigationBar.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit
import SnapKit

final class CustomNavigationBar: BaseView {
    let largeTitleLabel = UILabel()
    let titleView = UIView()
    let titleLabel = UILabel()
    let logoImageView = UIImageView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let textField = UITextField()
    private let line = UIView()
    
    init() {
        largeTitleLabel.isHidden = true
        leftButton.isHidden = true
        titleView.isHidden = true
        rightButton.isHidden = true
        textField.isHidden = true
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        [largeTitleLabel, titleView, leftButton, rightButton, textField, line].forEach { view in
            addSubview(view)
        }
        [titleLabel, logoImageView].forEach { view in
            titleView.addSubview(view)
        }
    }
    
    override func configureLayout() {
        largeTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(4)
            make.trailing.centerY.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(leftButton.snp.height)
        }
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(rightButton.snp.height)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        line.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
        
        largeTitleLabel.textAlignment = .left
        largeTitleLabel.font = Resource.SystemFont.heavy18
        largeTitleLabel.textColor = .labelMain
        
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 12
        
        titleLabel.font = Resource.SystemFont.bold16
        titleLabel.textColor = .labelMain
        
        let config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))
        leftButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        leftButton.tintColor = .labelMain
        
        rightButton.setImage(UIImage(named: "star"), for: .normal)
        rightButton.setImage(UIImage(named: "star_fill"), for: .selected)
        rightButton.tintColor = .labelMain
        
        textField.borderStyle = .none
        textField.font = Resource.SystemFont.regular14
        textField.tintColor = .labelMain
        textField.textColor = .labelMain
        
        line.backgroundColor = .backgroundSecondary
    }
}
