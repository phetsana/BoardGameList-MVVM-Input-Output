//
//  ImageLoader.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    var cacheSubscription: AnyCancellable?

    init(url: URL) {
        cacheSubscription = ImageCache
            .image(for: url)
            .replaceError(with: nil)
            .receive(on: RunLoop.main, options: .none)
            .assign(to: \.image, on: self)
    }
}
