//
//  NetworkingServiceImpl.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 19/09/2020.
//

import Foundation
import Combine

class NetworkingServiceImpl: NetworkingService {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func send<T: NetworkingRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkingError> {
        do {
            let endpoint = try self.endpoint(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared
                .dataTaskPublisher(for: endpoint)
                .map { $0.data }
                .decode(type: T.Response.self, decoder: decoder)
                .mapError { NetworkingError.other($0) }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkingError.endpoint).eraseToAnyPublisher()
        }
    }

    func endpoint<T: NetworkingRequest>(for request: T) throws -> URL {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw NetworkingError.endpoint
        }
        urlComponents.path = request.resourceName

        // Custom query items needed for this specific request
        let customQueryItems: [URLQueryItem]

        do {
            customQueryItems = try URLQueryItemEncoder.encode(request)
        } catch {
            throw NetworkingError.endpoint
        }

        urlComponents.queryItems = customQueryItems

        guard let url = urlComponents.url else {
            throw NetworkingError.endpoint
        }

        // Construct the final URL with all the previous data
        return url
    }
}

/// Encodes any encodable to a URLQueryItem list
enum URLQueryItemEncoder {
    static func encode<T: Encodable>(_ encodable: T) throws -> [URLQueryItem] {
        let parametersData = try JSONEncoder().encode(encodable)
        let parameters = try JSONDecoder().decode([String: HTTPParameter].self, from: parametersData)
        return parameters.map { URLQueryItem(name: $0, value: $1.description) }
    }
}

// Utility type so that we can decode any type of HTTP parameter
// Useful when we have mixed types in a HTTP request
enum HTTPParameter: CustomStringConvertible, Decodable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else {
            throw NetworkingError.decoding
        }
    }

    var description: String {
        switch self {
        case .string(let string):
            return string
        case .bool(let bool):
            return String(describing: bool)
        case .int(let int):
            return String(describing: int)
        case .double(let double):
            return String(describing: double)
        }
    }
}
