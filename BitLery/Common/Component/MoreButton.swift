//
//  MoreButton.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import UIKit

final class MoreButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("더보기", attributes: AttributeContainer([.font: Resource.SystemFont.regular14]))
        config.baseForegroundColor = .labelSecondary
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12))
        config.image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

