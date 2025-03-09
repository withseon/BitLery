//
//  TitleLabel.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import UIKit

final class TitleLabel: UILabel {
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        font = Resource.SystemFont.bold14
        textColor = .labelMain
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
