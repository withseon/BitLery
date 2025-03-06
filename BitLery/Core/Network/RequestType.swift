//
//  RequestType.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestType {
    var baseURL: URL { get }
    var method: Method { get }
    var parameter: [String: Any] { get }
    var header: [String: String] { get }
    var components: URLComponents? { get }
    var request: URLRequest { get }
}

extension RequestType {
    var components: URLComponents? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = parameter.map({ (key, value) in
            URLQueryItem(name: key, value: String(describing: value))
        })
        return components
    }
    
    var request: URLRequest {
        let url = components?.url
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        return request
    }
}
