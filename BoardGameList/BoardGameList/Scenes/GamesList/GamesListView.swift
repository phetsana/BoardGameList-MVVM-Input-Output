//
//  GamesListView.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import SwiftUI
import Rswift
import Combine

struct GamesListView: View {

    @EnvironmentObject
        var viewModel: GamesListViewModel

    var games: [GamesListViewModel.GameItem] {
        return viewModel.output.games.value
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle(R.string.localizable.game_list_title(), displayMode: .inline)
        }
        .onAppear { viewModel.input.onAppear.send(()) }
    }
    
    private var content: some View {        
        if games.isEmpty {
            return Spinner(isAnimating: true, style: .medium).eraseToAnyView()
        }
        
        return list()
            .eraseToAnyView()
    }

    private func list() -> some View {
        return List(games) { game in
            NavigationLink(
                destination: GameDetailView().environmentObject(GameDetailViewModel(game: game)),
                label: {
                    GameListItemView(game: game)
                })
        }
    }
}

struct GameListItemView: View {
    let game: GamesListViewModel.GameItem

    var body: some View {
        HStack {
            image.frame(width: 100, height: 100, alignment: .center)
            name
        }
    }

    private var name: some View {
        Text(game.name ?? "")
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }

    private var image: some View {
        return game.thumbURL.map { url in
            RemoteImage(url: url)
        }
    }
}

struct GamesListView_Previews: PreviewProvider {
    static let viewModel = GamesListViewModel()

    static var previews: some View {
        GamesListView()
            .environmentObject(Self.viewModel)
            .previewDisplayName("Default")
    }
}
