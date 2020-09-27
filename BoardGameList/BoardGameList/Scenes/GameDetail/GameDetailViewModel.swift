//
//  GameDetailViewModel.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 26/09/2020.
//

import Foundation
import Combine

final class GameDetailViewModel: ObservableObject, ViewModel {
    let input: Input
    let output: Output
    
    private(set) var game: GameItem
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let gameDriver: CurrentValueSubject<GameItem, Never>

    init(game: GamesListViewModel.GameItem) {
        self.game = GameItem(game: game)
        self.gameDriver = CurrentValueSubject<GameItem, Never>(self.game)
        
        self.output = Output(game: gameDriver)
        self.input = Input(onAppear: onAppearSubject)
        
        setUpBinding()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func setUpBinding() {
        onAppearSubject
            .sink { [weak self] _ in
                if let game = self?.game {
                    self?.gameDriver.send(game)
                }
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
}

extension GameDetailViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never>
    }
        
    struct Output {
        let game: CurrentValueSubject<GameItem, Never>
    }
    
    struct GameItem: Identifiable, Equatable {
        let id: String
        let name: String?
        let imageURL: URL?
        let description: String
        let playersTitle: String
        let playersText: String
        let descriptionTitle: String

        init(game: GamesListViewModel.GameItem) {
            id = game.id
            name = game.name
            imageURL = game.imageURL
            description = game.description ?? ""
            
            playersTitle = R.string.localizable.game_detail_players() + ":"
            playersText = "\(game.minPlayers) - \(game.maxPlayers)"
            descriptionTitle = R.string.localizable.game_detail_description() + ":"
        }
    }
}
