//
//  NetworkingService.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 07/09/2020.
//

import Foundation
import Combine

protocol NetworkingService {
    /// Send request over networking client
    ///
    /// - Parameter request: The request to send
    /// - Returns: A publisher of request response type and an error
    func send<T: NetworkingRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkingError>
}
