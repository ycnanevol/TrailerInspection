//
//  ServiceManagerFactory.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation


public class ServiceManagerFactory {
    
    public class func buildDefaultUsingRequestManager(requestManager : Manager) -> ServiceManager {
        
        var authService = AuthenticationService(requestManager: requestManager)
        var trailerService = TrailerService(requestManager: requestManager)
        
        return ServiceManager(initialLinks: Constants.serviceLinks, authenticationService: authService, trailerService: trailerService)
    }
    
}
