//
//  AnalyticsManagerFactory.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class AnalyticsManagerFactory {
    
    public class func buildDefaultAnalyticsManager() -> AnalyticsManager {
        
        var analyticsCollection : [AnyObject] = []
        
        analyticsCollection.append(AmplitudeWrapper())
        analyticsCollection.append(FlurryWrapper())
        analyticsCollection.append(GoogleAnalyticsWrapper())
        
        // Crashlytics should usually come last, so that it can catch crashes after everything else
        analyticsCollection.append(CrashlyticsWrapper())
        
        var manager = AnalyticsManager(analyticsCollection: analyticsCollection)
        
        wernerLoggers.append(manager)
        
        return manager
    }
    
}