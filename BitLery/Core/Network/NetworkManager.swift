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
    static func executeFetch<R: RequestType, T: Decodable>(router: R, response: T.Type) -> Observable<Result<T, NetworkError>> {
        return Single.create { value in
            URLSession.shared.dataTask(with: router.request) { data, response, error in
                if let error {
                    let networkError = NetworkError.transport(error)
                    value(.success(.failure(networkError)))
                    print(networkError.debugMessage)
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
                            let networkError = NetworkError.decoding(error)
                            value(.success(.failure(networkError)))
                            print(networkError.debugMessage)
                        }
                    } else {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let result = try decoder.decode(APIErrorResponse.self, from: data)
                            let networkError = NetworkError.server(error: result, statusCode: response.statusCode)
                            value(.success(.failure(networkError)))
                            print(networkError.debugMessage)
                        } catch {
                            let networkError = NetworkError.decodingServer(error: error, statusCode: response.statusCode)
                            value(.success(.failure(networkError)))
                            print(networkError.debugMessage)
                        }
                    }
                } else {
                    value(.success(.failure(.missingData)))
                }
            }.resume()
            return Disposables.create()
        }.asObservable()
    }
}
