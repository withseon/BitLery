//
//  Requestable.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

protocol Requestable: Encodable {
    var toDictionary : [String: Any] { get }
}

extension Requestable {
    var toDictionary : [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let object = try? encoder.encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return [:] }
        return dictionary
    }
}
