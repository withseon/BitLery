//
//  APIErrorResponse.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import Foundation

struct APIErrorResponse: Decodable, Error {
    let errorCode: Int?
    let errorMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case error
    }
    
    private enum StatusKeys: String, CodingKey {
        case errorCode
        case errorMessage
    }
    
    private enum ErrorObjectKeys: String, CodingKey {
        case message
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // coingecko
        // { "status": { "error_code":, "error_message": } }
        if let statusContainer = try? container.nestedContainer(keyedBy: StatusKeys.self, forKey: .status) {
            errorCode = try statusContainer.decode(Int.self, forKey: .errorCode)
            errorMessage = try statusContainer.decode(String.self, forKey: .errorMessage)
            return
        }
        
        // coingecko
        // { "error": }
        if let errorMessage = try? container.decode(String.self, forKey: .error) {
            self.errorCode = nil
            self.errorMessage = errorMessage
            return
        }
        
        // upbit
        // { "error": { "name": , "message" } }
        if let errorContainer = try? container.nestedContainer(keyedBy: ErrorObjectKeys.self, forKey: .error) {
            self.errorCode = nil
            self.errorMessage = try errorContainer.decode(String.self, forKey: .message)
            return
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: container.codingPath,
                                  debugDescription: "An indication that the data is corrupted or otherwise invalid.")
        )
    }
}
