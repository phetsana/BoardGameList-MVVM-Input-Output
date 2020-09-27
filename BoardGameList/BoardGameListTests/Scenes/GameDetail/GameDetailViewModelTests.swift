//
//  GameDetailViewModelTests.swift
//  BoardGameListTests
//
//  Created by Phetsana PHOMMARINH on 27/09/2020.
//

import XCTest
@testable import BoardGameList
import Combine
import Rswift

private enum GameDetailViewModelTestsError: Error {
    case error
}

class GameDetailViewModelTests: XCTestCase {

    var sut: GameDetailViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    static var deinitCalled = false
    
    override func setUp() {
        sut = GameDetailViewModel(game: Self.gameListItem())
    }
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    static func gameListItem() -> GamesListViewModel.GameItem {
        let gameDTO =
            GameDTO(id: "game id",
                    name: "Detective Club",
                    imageUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQw71ksfWx6nRCU32a5VAdBuMmURsOCD6U9xQ&usqp=CAU"),
                    thumbUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQw71ksfWx6nRCU32a5VAdBuMmURsOCD6U9xQ&usqp=CAU"),
                    yearPublished: 2007,
                    minPlayers: 3, maxPlayers: 6,
                    description: "Description ablabla",
                    primaryPublisher: "Publisher",
                    rank: 2, trendingRank: 4)
        let gameListItem = GamesListViewModel.GameItem(game: gameDTO)
        return gameListItem
    }
    
    func test_onAppear_game() {
        let gamesExpectation = self.expectation(description: "games loarding")
        gamesExpectation.expectedFulfillmentCount = 2
        sut?.output.game.sink(receiveCompletion: { (_) in
        }, receiveValue: { (_) in
            gamesExpectation.fulfill()
        })
        .store(in: &subscriptions)
        
        sut?.input.onAppear.send(())
        
        wait(for: [gamesExpectation], timeout: 0.5)
        
        let game = sut?.output.game.value
        XCTAssertNotNil(game)
        XCTAssertEqual(game?.name, "Detective Club")
        XCTAssertEqual(game?.id, "game id")
        XCTAssertEqual(game?.imageURL, URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQw71ksfWx6nRCU32a5VAdBuMmURsOCD6U9xQ&usqp=CAU"))
        XCTAssertEqual(game?.playersTitle, R.string.localizable.game_detail_players() + ":")
        XCTAssertEqual(game?.playersText, "3 - 6")
        XCTAssertEqual(game?.descriptionTitle, R.string.localizable.game_detail_description() + ":")
        XCTAssertEqual(game?.description, "Description ablabla")
    }
}
