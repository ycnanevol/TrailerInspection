//
//  AnalyticsManager.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class AnalyticsManager {
    
    private var analyticsWithApiKey : [AnalyticsWithApiKey] = []
    private var appLoggers : [AppLoggingAnalytics] = []
    private var appTrackers : [AppTrackingAnalytics] = []
    private var crashDetectors : [CrashDetector] = []
    private var screenTrackers : [ScreenTrackingAnalytics] = []
    private var userTrackers : [UserTrackingAnalytics] = []
    
    var analyticsCollection : [AnyObject]! {
        didSet {
            rebuildArrays()
        }
    }
    
    public init() {}
    
    public convenience init(analyticsCollection : [AnyObject]) {
        self.init()
        
        self.analyticsCollection = analyticsCollection
        
        rebuildArrays()
    }
    
    func rebuildArrays() {
        analyticsWithApiKey.removeAll(keepCapacity: true)
        appLoggers.removeAll(keepCapacity: true)
        appTrackers.removeAll(keepCapacity: true)
        crashDetectors.removeAll(keepCapacity: true)
        screenTrackers.removeAll(keepCapacity: true)
        userTrackers.removeAll(keepCapacity: true)
        
        for object in analyticsCollection {
            if let withApiKey = object as? AnalyticsWithApiKey {
                analyticsWithApiKey.append(withApiKey)
            }
            
            if let appLogger = object as? AppLoggingAnalytics {
                appLoggers.append(appLogger)
            }
            
            if let appTracker = object as? AppTrackingAnalytics {
                appTrackers.append(appTracker)
            }
            
            if let crashDetector = object as? CrashDetector {
                crashDetectors.append(crashDetector)
            }
            
            if let screenTracker = object as? ScreenTrackingAnalytics {
                screenTrackers.append(screenTracker)
            }
            
            if let userTracker = object as? UserTrackingAnalytics {
                userTrackers.append(userTracker)
            }
        }
    }
    
    // MARK: API key
    public func initializeAnalytics() {
        for analyticsWithApi in analyticsWithApiKey {
            analyticsWithApi.configureApiKey()
        }
    }
    
    // MARK: App tracking
    public func collectAppDetails(appDelegate : AppDelegate) {
        for appTracker in appTrackers {
            #if DEBUG
                appTracker.setDebugMode(true)
            #else
                appTracker.setDebugMode(false)
            #endif
        }
    }
    
    // MARK: Crash detection
    public func startCrashDetection() {
        for crashDetector in crashDetectors {
            crashDetector.startCrashDetection()
        }
    }
    
    public func simulateCrash() {
        for crashDetector in crashDetectors {
            crashDetector.simulateCrash()
        }
        
        WernerLog("Simulating crash manually")
        abort()
    }
    
    // MARK: Screen/event tracking
    public func screenDidAppear(screenName : String, withNewSession newSession : Bool = false) {
        WernerLog("Screen in: \(screenName)")
        for screenTracker in screenTrackers {
            screenTracker.screenDidAppear(screenName, withNewSession: newSession)
        }
    }
    
    public func eventDidHappen(eventName : String) {
        WernerLog("Event triggered: \(eventName)")
        for screenTracker in screenTrackers {
            screenTracker.eventDidHappen(eventName)
        }
    }
    
    public func screenWillDisappear(screenName : String) {
        WernerLog("Screen out: \(screenName)")
        for screenTracker in screenTrackers {
            screenTracker.screenWillDisappear(screenName)
        }
    }
    
    // MARK: User tracking
    private var _activeUserIdentifier : String!
    public var activeUserIdentifier : String! {
        get {
            return _activeUserIdentifier
        }
        set {
            _activeUserIdentifier = newValue
            
            for userTracker in userTrackers {
                userTracker.setActiveUserIdentifier(newValue)
            }
        }
    }
    
    private var _activeUserFullName : String!
    public var activeUserFullName : String! {
        get {
            return _activeUserFullName
        }
        set {
            _activeUserFullName = newValue
            
            for userTracker in userTrackers {
                userTracker.setActiveUserFullName(newValue)
            }
        }
    }
    
    private var _activeUserEmail : String!
    public var activeUserEmail : String! {
        get {
            return _activeUserEmail
        }
        set {
            _activeUserEmail = newValue
            
            for userTracker in userTrackers {
                userTracker.setActiveUserEmail(newValue)
            }
        }
    }
    
}

// MARK: - WernerLogDelegate extension
extension AnalyticsManager : WernerLogDelegate {
    
    public func log(format : String, args : CVarArgType...) {
        logv(format, args: getVaList(args))
    }
    
    public func logv(format : String, args : CVaListPointer) {
        for logger in appLoggers {
            logger.logv(format, args: args)
        }
    }
    
}


