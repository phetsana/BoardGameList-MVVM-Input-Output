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

struct GameDetailView_Previews: PreviewProvider {
    static let gameDTO =
        GameDTO(id: "game id",
                name: "Detective Club",
                imageUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQw71ksfWx6nRCU32a5VAdBuMmURsOCD6U9xQ&usqp=CAU"),
                thumbUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQw71ksfWx6nRCU32a5VAdBuMmURsOCD6U9xQ&usqp=CAU"),
                yearPublished: 2007,
                minPlayers: 3, maxPlayers: 6,
                description: "Description ablabla",
                primaryPublisher: "Publisher",
                rank: 2, trendingRank: 4)
    static let gameItem = GamesListViewModel.GameItem(game: Self.gameDTO)
    static let viewModel = GameDetailViewModel(game: Self.gameItem)

    static var previews: some View {
        GameDetailView()
            .environmentObject(Self.viewModel)
            .previewDisplayName("Default")
    }
}
