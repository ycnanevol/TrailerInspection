//
//  CrashlyticsWrapper.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

public class CrashlyticsWrapper {
    
    let crashlytics : Crashlytics

    public init(crashlytics : Crashlytics) {
        self.crashlytics = crashlytics
    }
    
    public convenience init() {
        self.init(crashlytics : Crashlytics.sharedInstance())
    }
    
}

// MARK: - App tracking
extension CrashlyticsWrapper : AppTrackingAnalytics {
    
    public func setDebugMode(isDebug: Bool) {
        crashlytics.setBoolValue(isDebug, forKey: "DEBUG")
    }
    
}

// MARK: - App Logging
extension CrashlyticsWrapper : AppLoggingAnalytics {
    
    public func logv(format : String, args : CVaListPointer) {
        CLSLogv(format, args)
    }
    
}

// MARK: - Crash detection
extension CrashlyticsWrapper : CrashDetector {

    public func startCrashDetection() -> Void {
        Fabric.with([ crashlytics ])
    }
    
    public func simulateCrash() -> Void {
        crashlytics.crash()
    }
    
}

// MARK: - User tracking
extension CrashlyticsWrapper : UserTrackingAnalytics {

    public func setActiveUserIdentifier(identifier : String!) -> Void {
        crashlytics.setUserIdentifier(identifier)
    }
    
    public func setActiveUserFullName(fullName : String!) {
        crashlytics.setUserName(fullName)
    }
    
    public func setActiveUserEmail(email : String!) {
        crashlytics.setUserEmail(email)
    }
    
}
