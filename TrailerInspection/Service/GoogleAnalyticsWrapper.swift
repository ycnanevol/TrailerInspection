//
//  GoogleAnalyticsWrapper.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-04.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class GoogleAnalyticsWrapper {
    
    var gai : GAI
    var tracker : GAITracker!
    
    public init(gai : GAI) {
        self.gai = gai
        
        gai.logger = WernerGAILoggerWrapper()
        
        #if DEBUG
            gai.logger.logLevel = .Info
        #endif
    }
    
    public convenience init() {
        self.init(gai: GAI.sharedInstance())
    }
    
    
}

// MARK: - API key
extension GoogleAnalyticsWrapper : AnalyticsWithApiKey {
    
    public func configureApiKey() {
        // TODO(rgrimm): Get the tracking ID based on environment (dev/cre/prod)
        tracker = gai.trackerWithTrackingId("UA-62508096-4")
    }
    
}

// MARK: - Screen tracking
extension GoogleAnalyticsWrapper : ScreenTrackingAnalytics {
    
    public func screenDidAppear(screenName: String, withNewSession newSession : Bool) {
        tracker.set(kGAIScreenName, value: screenName)
        
        var builder = GAIDictionaryBuilder.createScreenView()
        
        if newSession {
            builder.set("start", forKey: kGAISessionControl)
        }
        
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    public func eventDidHappen(eventName: String) {
        // TODO(rgrimm): Look for way to track non-screen events
    }
    
    public func screenWillDisappear(screenName: String) {
        // Google Analytics doesn't track screen disappearing
    }
    
}

// MARK: - User tracking
extension GoogleAnalyticsWrapper : UserTrackingAnalytics {
    
    public func setActiveUserIdentifier(identifier: String!) {
        tracker.set(GAIFields.customDimensionForIndex(1), value: identifier)
    }
    
    public func setActiveUserFullName(fullName: String!) {
        // Do not track this in GA
    }
    
    public func setActiveUserEmail(email: String!) {
        // Do not track this in GA
    }
    
}

// MARK: - WernerLog wrapper for GAILogger
public class WernerGAILoggerWrapper : NSObject, GAILogger {
    
    public var logLevel : GAILogLevel = .Warning
    
    public override init() {
        super.init()
    }
    
    public func verbose(message : String!) {
        switch logLevel {
        case .Verbose:
            WernerLog(message)
        default:
            if true {}
        }
    }
    
    public func info(message : String!) {
        switch logLevel {
        case .Info:
            fallthrough
        case .Verbose:
            WernerLog(message)
        default:
            if true {}
        }
    }
    
    public func warning(message : String!) {
        switch logLevel {
        case .Warning:
            fallthrough
        case .Info:
            fallthrough
        case .Verbose:
            WernerLog(message)
        default:
            if true {}
        }
    }
    
    public func error(message : String!) {
        switch logLevel {
        case .Error:
            fallthrough
        case .Warning:
            fallthrough
        case .Info:
            fallthrough
        case .Verbose:
            WernerLog(message)
        default:
            if true {}
        }
    }
    
}
