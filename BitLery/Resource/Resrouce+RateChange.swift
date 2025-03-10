//
//  Resource+RateChange.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import UIKit

struct RateChange {
    let color: UIColor
    let image: UIImage?
}

extension Resource {
    static func getRateResource(_ rate: Double) -> RateChange {
        if rate > 0 {
            return RateChange(color: .labelUp, image: UIImage(systemName: "arrowtriangle.up.fill"))
        } else if rate < 0 {
            return RateChange(color: .labelDown, image: UIImage(systemName: "arrowtriangle.down.fill"))
        } else {
            return RateChange(color: .labelMain, image: nil)
        }
    }
}
