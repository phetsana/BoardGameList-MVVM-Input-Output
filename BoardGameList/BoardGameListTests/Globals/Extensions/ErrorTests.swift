//
//  ErrorTests.swift
//  BoardGameListTests
//
//  Created by Phetsana PHOMMARINH on 27/09/2020.
//

import XCTest
@testable import BoardGameList

enum ErrorTestsError: Error {
    case error1
    case error2
}

class ErrorTests: XCTestCase {

    override func setUp() {
    }

    func test_error_equality() {
        let error1 = ErrorTestsError.error1
        let error2 = ErrorTestsError.error1
        let nsError1 = ErrorTestsError.error1 as NSError
        let nsError2 = ErrorTestsError.error1 as NSError

        XCTAssertEqual(error1.isEqual(to: error2), true)
        XCTAssertEqual(nsError1.isEqual(to: error2), true)
        XCTAssertEqual(error1.isEqual(to: nsError2), true)
        XCTAssertEqual(nsError1.isEqual(to: nsError2), true)
    }

    func test_error_no_equality() {
        let error1 = ErrorTestsError.error1
        let error2 = ErrorTestsError.error2
        let nsError1 = ErrorTestsError.error1 as NSError
        let nsError2 = ErrorTestsError.error2 as NSError
        
        XCTAssertEqual(error1.isEqual(to: error2), false)
        XCTAssertEqual(error1.isEqual(to: nsError2), false)
        XCTAssertEqual(nsError1.isEqual(to: error2), false)
        XCTAssertEqual(nsError1.isEqual(to: nsError2), false)
    }
    
    func test_nserror_equality() {
        let error1 = NSError(domain: "domain1", code: 1, userInfo: nil)
        let error2 = NSError(domain: "domain1", code: 1, userInfo: nil)
        
        XCTAssertEqual(error1.isEqual(to: error2), true)
    }
    
    func test_nserror_no_equality() {
        var error1 = NSError(domain: "domain1", code: 1, userInfo: nil)
        var error2 = NSError(domain: "domain2", code: 2, userInfo: nil)
        
        XCTAssertEqual(error1.isEqual(to: error2), false)
        
        error1 = NSError(domain: "domain1", code: 1, userInfo: nil)
        error2 = NSError(domain: "domain2", code: 1, userInfo: nil)
        
        XCTAssertEqual(error1.isEqual(to: error2), false)
        
        error1 = NSError(domain: "domain1", code: 1, userInfo: nil)
        error2 = NSError(domain: "domain1", code: 2, userInfo: nil)
        
        XCTAssertEqual(error1.isEqual(to: error2), false)
    }
}
