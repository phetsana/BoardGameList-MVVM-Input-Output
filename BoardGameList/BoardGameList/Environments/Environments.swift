//
//  Environment.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 20/09/2020.
//

import Foundation

enum Environments {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let serverURL = "SERVER_URL"
            static let clientID = "CLIENT_ID"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let serverURL: URL = {
        guard let rootURLstring = Environments.infoDictionary[Keys.Plist.serverURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()

    static let clientID: String = {
        guard let clientID = Environments.infoDictionary[Keys.Plist.clientID] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return clientID
    }()
}
