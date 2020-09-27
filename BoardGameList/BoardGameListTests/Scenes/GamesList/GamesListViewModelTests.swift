//
//  GamesListViewModelTests.swift
//  BoardGameListTests
//
//  Created by Phetsana PHOMMARINH on 27/09/2020.
//

import XCTest
@testable import BoardGameList
import Combine

private enum GamesListViewModelTestsError: Error {
    case error
}

class GamesListViewModelTests: XCTestCase {

    var sut: GamesListViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    static var deinitCalled = false
    
    override func setUp() {
        let networkingServiceMock = NetworkingServiceMock(file: "api_search")
        sut = GamesListViewModel(apiService: networkingServiceMock)
    }
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func test_onAppear_games() {
        var games = sut?.output.games.value
        XCTAssertEqual(games?.count, 0)
        
        let gamesExpectation = self.expectation(description: "games loarding")
        sut?.output.games.sink(receiveCompletion: { (_) in
        }, receiveValue: { (games) in
            if !games.isEmpty {
                gamesExpectation.fulfill()
            }
        })
        .store(in: &subscriptions)
        
        sut?.input.onAppear.send(())
        
        wait(for: [gamesExpectation], timeout: 0.5)
        
        games = sut?.output.games.value
        XCTAssertEqual(games?.count, 50)
    }
    
    func test_onAppear_error() {
        let networkingServiceMock = NetworkingServiceMock(file: "api_search",
                                                          error: GamesListViewModelTestsError.error)
        sut = GamesListViewModel(apiService: networkingServiceMock)
        
        var games = sut?.output.games.value
        XCTAssertEqual(games?.count, 0)
        
        let errorExpectation = self.expectation(description: "loading error")
        sut?.output.games.sink(receiveCompletion: { (completion) in
            if case .failure = completion {
                errorExpectation.fulfill()
            }
        }, receiveValue: { (_) in            
        })
        .store(in: &subscriptions)
        
        sut?.input.onAppear.send(())
        
        wait(for: [errorExpectation], timeout: 0.5)
        
        games = sut?.output.games.value
        XCTAssertEqual(games?.count, 0)
    }
    
    func test_deinit() {
        let apiClientMock = NetworkingServiceMock(file: "api_search")
        var sut: GamesListViewModelMock? = GamesListViewModelMock(apiService: apiClientMock)
        XCTAssertNotNil(sut)
        sut = nil
        XCTAssertNil(sut)
        XCTAssertEqual(GamesListViewModelTests.deinitCalled, true)
    }
}

private class GamesListViewModelMock: GamesListViewModel {
    deinit {
        GamesListViewModelTests.deinitCalled = true
    }
}
