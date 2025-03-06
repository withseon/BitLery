//
//  NetworkManager.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkManager {
    static func NetworkManager<R: RequestType, T: Decodable>(router: R, response: T.Type) -> Single<Result<T, NetworkError>> {
        return Single.create { value in
            URLSession.shared.dataTask(with: router.request) { data, response, error in
                if let _ = error {
                    value(.success(.failure(.transport)))
                }
                
                if let response = response as? HTTPURLResponse,
                   let data {
                    if (200...299).contains(response.statusCode) {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let result = try decoder.decode(T.self, from: data)
                            value(.success(.success(result)))
                        } catch {
                            print("❌ Network Response Decoding Error:: \(error)")
                            value(.success(.failure(.decoding)))
                        }
                    } else {
                        value(.success(.failure(.serverData(data: data, statusCode: response.statusCode))))
                    }
                } else {
                    value(.success(.failure(.missingData)))
                }
            }.resume()
            return Disposables.create()

        }
    }
}

