//
//  AuthenticatorTest.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import XCTest
import TrailerInspection

class ServiceManagerTest : XCTestCase {
    
    class AuthenticationServiceMock : AuthenticationService {
        
        var getTokenShouldSucceed = true
        
        override init(requestManager: Manager!) {
            super.init(requestManager: requestManager)
        }
        
        convenience init() {
            self.init(requestManager: nil)
        }
        
        override func getToken(links: [String : NSURL], username: String, password: String, handler: (token: Token?, nextLinks: [String : NSURL]?, message: String) -> Void) {
            if getTokenShouldSucceed {
                handler(token: Token(value: "Dummy Token"), nextLinks: nil, message: "OK")
            } else {
                handler(token: nil, nextLinks: nil, message: "NO")
            }
        }

    }
    
    class TrailerServiceMock : TrailerService {
        
    }
    
    var authService : AuthenticationServiceMock!
    var trailerService : TrailerService!
    var serviceManager : ServiceManager!
    
    override func setUp() {
        super.setUp()
        authService = AuthenticationServiceMock()
        trailerService = TrailerServiceMock()
        serviceManager = ServiceManager(initialLinks: [:], authenticationService: authService, trailerService: trailerService)
    }
    
    func testPerformLogin_Success() {
        authService.getTokenShouldSucceed = true
        
        XCTAssertFalse(serviceManager.isAuthenticated, "default state should be not authenticated")
        
        let expectation = self.expectationWithDescription("Expectation that performLogin will always call the handler")
        
        serviceManager.performLogin(username: "dummy", password: "dummy") { (success, message) -> Void in
            XCTAssertTrue(success, "Success should be true")
            XCTAssertTrue(self.serviceManager.isAuthenticated, "isAuthenticated should match success")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) -> Void in
            // TODO(rgrimm): Cancel the request if timeout reached
        }
    }
    
    func testPerformLogin_Failure() {
        authService.getTokenShouldSucceed = false
        
        XCTAssertFalse(serviceManager.isAuthenticated, "default state should be not authenticated")
        
        let expectation = self.expectationWithDescription("Expectation that performLogin will always call the handler")
        
        serviceManager.performLogin(username: "dummy", password: "dummy") { (success, message) -> Void in
            XCTAssertFalse(success, "Success should be false")
            XCTAssertFalse(self.serviceManager.isAuthenticated, "isAuthenticated should match success")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) -> Void in
            // TODO(rgrimm): Cancel the request if timeout reached
        }
    }
    
}
