//
//  AnalyticsManagerTest.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-04.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import XCTest
import TrailerInspection

class AnalyticsManagerTest : XCTestCase {
    
    class AppDelegateMock : AppDelegate {
        
    }
    
    class AppTrackerMock : AppTrackingAnalytics {
        var setDebugWasCalled : Bool = false
        var setDebugCalledWith : Bool?
        
        func setDebugMode(isDebug: Bool) {
            setDebugWasCalled = true
            setDebugCalledWith = isDebug
        }
    }

    var appTracker : AppTrackerMock!
    
    var analyticsManager : AnalyticsManager!
    
    override func setUp() {
        super.setUp()
        
        appTracker = AppTrackerMock()
        analyticsManager = AnalyticsManager(analyticsCollection: [
            appTracker,
        ])
    }
    
    func testCollectAppDetails_Delegates() {
        analyticsManager.collectAppDetails(AppDelegateMock())
        
        XCTAssert(appTracker.setDebugWasCalled, "AppTrackingAnalytics::setDebugMode() was not called from AnalyticsManager.collectAppDetails()")
    }
    
}
