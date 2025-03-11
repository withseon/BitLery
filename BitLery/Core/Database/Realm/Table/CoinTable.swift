//
//  CoinTable.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import Foundation
import RealmSwift

final class CoinTable: Object {
    @Persisted(primaryKey: true) var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
