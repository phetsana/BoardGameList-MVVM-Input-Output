//
//  NetworkingError.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 07/09/2020.
//

import Foundation

/// API errors
public enum NetworkingError: Error {
    case encoding
    case decoding
    case endpoint
    case other(Error)
}
