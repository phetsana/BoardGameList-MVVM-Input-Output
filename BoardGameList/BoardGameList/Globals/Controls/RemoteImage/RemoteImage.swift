//
//  RemoteImage.swift
//  BoardGameAtlasTest
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import SwiftUI

struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader

    init(url: URL) {
        self.imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        Group {
            if imageLoader.image != nil {
                imageLoader
                    .image
                    .map { Image(uiImage: $0).resizable() }
                    .aspectRatio(contentMode: .fit)
            } else {
                Spinner(isAnimating: true, style: .medium)
            }
        }
    }
}
