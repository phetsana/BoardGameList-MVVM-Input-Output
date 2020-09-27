//
//  NetworkingRequest.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 07/09/2020.
//

import Foundation

/// API protocol request
public protocol NetworkingRequest: Encodable {
    /// Response (will be wrapped with a DataContainer)
    associatedtype Response: Decodable

    /// Endpoint for this request (the last part of the URL)
    var resourceName: String { get }

    /// Request parameters
    var parameters: [String: Any] { get }
}
