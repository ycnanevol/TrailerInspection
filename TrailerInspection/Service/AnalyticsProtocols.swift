//
//  AnalyticsProtocols.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public protocol AnalyticsWithApiKey {
    func configureApiKey() -> Void
}

public protocol AppLoggingAnalytics {
    func logv(format : String, args : CVaListPointer) -> Void
}

public protocol AppTrackingAnalytics {
    func setDebugMode(isDebug : Bool) -> Void
}

public protocol CrashDetector {
    func startCrashDetection() -> Void
    func simulateCrash() -> Void
}

public protocol ScreenTrackingAnalytics {
    func screenDidAppear(screenName : String, withNewSession : Bool) -> Void
    func eventDidHappen(eventName : String) -> Void
    func screenWillDisappear(screenName : String) -> Void
}

public protocol UserTrackingAnalytics {
    func setActiveUserIdentifier(identifier : String!) -> Void
    func setActiveUserFullName(fullName : String!) -> Void
    func setActiveUserEmail(email : String!) -> Void
}
