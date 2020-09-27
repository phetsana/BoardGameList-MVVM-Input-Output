//
//  GameDetailView.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 26/09/2020.
//

import SwiftUI

struct GameDetailView: View {
    @EnvironmentObject
    var viewModel: GameDetailViewModel
    
    var game: GameDetailViewModel.GameItem {
        viewModel.output.game.value
    }
    
    var body: some View {
        content
            .navigationTitle(game.name ?? "")
            .onAppear { self.viewModel.input.onAppear.send(()) }
    }

    private var content: some View {
        return ScrollView {
            GameDetailItemView(game: game)
                .padding(20)
        }
        .eraseToAnyView()
    }
}

struct GameDetailItemView: View {
    let game: GameDetailViewModel.GameItem

    var body: some View {
        VStack {
            image
            players
            description
        }
    }

    private var image: some View {
        return game.imageURL.map { url in
            RemoteImage(url: url)
        }
    }

    private var players: some View {
        HStack {
            Text(game.playersTitle)
                .bold()
            Text(game.playersText)
        }
    }

    private var description: some View {
        VStack {
            Text(game.descriptionTitle)
                .bold()
            Text(game.description)
        }
        .eraseToAnyView()
    }
}
