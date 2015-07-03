//
//  FlurryWrapper.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-04.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class FlurryWrapper {
    
    public init() {
        #if DEBUG
            Flurry.setDebugLogEnabled(true)
        #endif
    }
    
}

// MARK: - API key
extension FlurryWrapper : AnalyticsWithApiKey {
    
    public func configureApiKey() {
        // TODO(rgrimm): Get API key based on environment
        Flurry.startSession("9DP2G5TV996NST6R6QXR")
    }
    
}

// MARK: - Crash detection
extension FlurryWrapper : CrashDetector {
    
    public func startCrashDetection() {
        Flurry.setCrashReportingEnabled(true)
    }
    
    public func simulateCrash() {
        // Let this fall through to be handled either by Crashlytics or the manager itself
    }
    
}

// MARK: - Screen tracking
extension FlurryWrapper : ScreenTrackingAnalytics {
    
    public func screenDidAppear(screenName: String, withNewSession: Bool) {
        Flurry.logEvent(screenName, timed: true)
        Flurry.logPageView()
    }
    
    public func eventDidHappen(eventName: String) {
        Flurry.logEvent(eventName)
    }
    
    public func screenWillDisappear(screenName: String) {
        Flurry.endTimedEvent(screenName, withParameters: nil)
    }
    
}
