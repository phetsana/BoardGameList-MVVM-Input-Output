//
//  NetworkingServiceMock.swift
//  BoardGameListTests
//
//  Created by Phetsana PHOMMARINH on 27/09/2020.
//

import Foundation
import Combine
@testable import BoardGameList

final class NetworkingServiceMock: NetworkingService {

    private let file: String
    private let type: String
    private let error: Error?
    init(file: String, type: String = "json", error: Error? = nil) {
        self.file = file
        self.type = type
        self.error = error
    }

    func data(with file: String, ofType: String = "json") -> Data? {
        let bundle = Bundle(for: Swift.type(of: self))
        if let path = bundle.path(forResource: file, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }

        return nil
    }

    func send<T>(_ request: T) -> AnyPublisher<T.Response, NetworkingError> where T: NetworkingRequest {
        let data = self.data(with: file, ofType: type)!
        return Future<T.Response, Error> { [weak self] (promise) in
            if let error = self?.error {
                return promise(.failure(error))
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let mappingData = try decoder.decode(T.Response.self, from: data)
                return promise(.success(mappingData))
            } catch {
                return promise(.failure(error))
            }
        }
        .mapError { NetworkingError.other($0) }
        .eraseToAnyPublisher()
    }
}
