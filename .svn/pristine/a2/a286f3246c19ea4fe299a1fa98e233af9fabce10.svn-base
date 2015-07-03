//
//  AmplitudeWrapper.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-05.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class AmplitudeWrapper {
    
    var amplitude : Amplitude
    
    public init(amplitude : Amplitude) {
        self.amplitude = amplitude
    }
    
    public convenience init() {
        self.init(amplitude: Amplitude())
    }
    
}

extension AmplitudeWrapper : AnalyticsWithApiKey {

    public func configureApiKey() {
        // TODO(rgrimm): Get API key based on environment
        amplitude.initializeApiKey("96117786a35ce1808d208a17418d52a2")
    }
    
}

extension AmplitudeWrapper : ScreenTrackingAnalytics {
    
    public func screenDidAppear(screenName: String, withNewSession: Bool) {
        amplitude.logEvent(screenName)
    }
    
    public func eventDidHappen(eventName: String) {
        amplitude.logEvent(eventName)
    }
    
    public func screenWillDisappear(screenName: String) {
        // Amplitude doesn't track screen exits
    }
    
}

extension AmplitudeWrapper : UserTrackingAnalytics {
    
    public func setActiveUserIdentifier(identifier: String!) {
        if let userId = identifier {
            amplitude.setUserProperties([ "authenticationToken": userId ])
        } else {
            amplitude.setUserProperties([ "authenticationToken": "" ])
        }
    }
    
    public func setActiveUserFullName(fullName: String!) {
        // Do not track this in Amplitude
    }
    
    public func setActiveUserEmail(email: String!) {
        // Do not track this in Amplitude
    }
    
}
