//
//  GamesListViewModel.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import Foundation
import Combine

enum GamesListViewModelError: Error {
    case loading
    case other(Error)
}

class GamesListViewModel: ObservableObject, ViewModel {
    let input: Input
    let output: Output
    
    @Published var games: [GameItem] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let gamesDriver = CurrentValueSubject<[GameItem], GamesListViewModelError>([])

    private let apiService: NetworkingService
    
    init(apiService: NetworkingService = BoardGameAtlasNetworkingServiceImpl()) {
        self.apiService = apiService

        self.output = Output(games: gamesDriver)
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
                self?.fetchGames()
            }
            .store(in: &subscriptions)
    }
    
    private func fetchGames() {
        let request = GetGamesRequest()
        apiService
            .send(request)
            .map { $0.games.map(GameItem.init) }
            .receive(on: RunLoop.main)
            .mapError { _ in return GamesListViewModelError.loading }
            .sink { [weak self] (completion) in
                if case .failure = completion {
                    self?.gamesDriver.send(completion: completion)
                    self?.objectWillChange.send()
                }
            } receiveValue: { [weak self] (games) in
                self?.gamesDriver.send(games)
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
}

extension GamesListViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never>
    }
        
    struct Output {
        let games: CurrentValueSubject<[GameItem], GamesListViewModelError>
    }
    
    struct GameItem: Identifiable, Equatable {
        let id: String
        let name: String?
        let imageURL: URL?
        let thumbURL: URL?
        let description: String?
        let minPlayers: Int
        let maxPlayers: Int

        init(game: GameDTO) {
            id = game.id
            name = game.name
            imageURL = game.imageUrl
            thumbURL = game.thumbUrl
            description = game.description
            minPlayers = game.minPlayers
            maxPlayers = game.maxPlayers
        }
    }
}
