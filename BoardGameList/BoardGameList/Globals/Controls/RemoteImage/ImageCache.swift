//
//  ImageCache.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import UIKit
import Combine

class ImageCache {

    enum Error: Swift.Error {
        case dataConversionFailed
        case sessionError(Swift.Error)
    }

    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    private init() { }

    static func image(for url: URL) -> AnyPublisher<UIImage?, ImageCache.Error> {

        guard let image = shared.cache.object(forKey: url as NSURL) else {
            return URLSession
                .shared
                .dataTaskPublisher(for: url)
                .tryMap { (tuple) -> UIImage in
                    let (data, _) = tuple
                    guard let image = UIImage(data: data) else {
                        throw Error.dataConversionFailed
                    }
                    shared.cache.setObject(image, forKey: url as NSURL)
                    return image
                }
                .mapError({ error in Error.sessionError(error) })
                .eraseToAnyPublisher()
        }

        return Just(image)
            .setFailureType(to: ImageCache.Error.self)
            .eraseToAnyPublisher()
    }
}
