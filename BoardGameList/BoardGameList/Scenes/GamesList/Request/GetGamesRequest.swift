//
//  GetGamesRequest.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 07/09/2020.
//

import Foundation

enum OrderBy: String, Codable {
    case popularity
}

struct GetGamesRequest: NetworkingRequest {

    typealias Response = GamesDTO

    var resourceName: String {
        return "/api/search"
    }

    private let orderBy: OrderBy
    private let ascending: Bool
    private let limit: Int
    init(orderBy: OrderBy = .popularity,
         ascending: Bool = false,
         limit: Int = 50) {
        self.orderBy = orderBy
        self.ascending = ascending
        self.limit = limit
    }

    var parameters: [String: Any] {
        return [
            "order_by": orderBy.rawValue,
            "ascending": ascending,
            "limit": limit
        ]
    }
}
