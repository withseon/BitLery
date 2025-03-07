//
//  Resource+SystemFont.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit

extension Resource {
    enum SystemFont {
        static let regular9: UIFont = .systemFont(ofSize: 9)
        static let regular12: UIFont = .systemFont(ofSize: 12)
        
        static let bold9: UIFont = .boldSystemFont(ofSize: 9)
        static let bold12: UIFont = .boldSystemFont(ofSize: 12)
        static let bold16: UIFont = .boldSystemFont(ofSize: 16)
        
        static let navigationLargeTitle: UIFont = .systemFont(ofSize: 19, weight: .heavy)
        static let navigationTitle: UIFont = .systemFont(ofSize: 16, weight: .bold)
        static let navigationButton: UIFont = .systemFont(ofSize: 20, weight: .bold)
    }
}
