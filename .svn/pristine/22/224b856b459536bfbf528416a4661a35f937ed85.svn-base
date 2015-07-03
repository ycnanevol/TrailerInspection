//
//  ServiceManager.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class ServiceManager {
    
    public var analyticsManager : AnalyticsManager? {
        didSet {
            setAnalyticsInfo()
        }
    }
    
    var authService : AuthenticationService
    var trailerService : TrailerService
    
    var currentAuthToken : Token? {
        willSet {
            if currentAuthToken != newValue {
                let currentString : String
                let newString : String
                
                // Remove Optional(...) from currentAuthToken's string
                if let currentAuthToken = currentAuthToken {
                    currentString = "\(currentAuthToken)"
                } else {
                    currentString = "\(currentAuthToken)"
                }
                
                // Remove Optional(...) text from newValue's string
                if let newValue = newValue {
                    newString = "\(newValue)"
                } else {
                    newString = "\(newValue)"
                }
                
                WernerLog("Authorization token changing: %@ -> %@", currentString, newString)
            }
        }
        didSet {
            setAnalyticsInfo()
        }
    }
    
    // Richardson Maturity Model 3 seed links
    let initialLinks : [String : NSURL]
    
    private var _availableLinks : [String : NSURL]
    var availableLinks : [String : NSURL] {
        get {
            return _availableLinks
        }
        set {
            if newValue.isEmpty {
                _availableLinks = initialLinks
            } else {
                _availableLinks = newValue
            }
        }
    }
    
    public init(initialLinks : [String : String], authenticationService : AuthenticationService, trailerService : TrailerService) {
        self.initialLinks = Support.mapLinks(initialLinks)!
        self._availableLinks = self.initialLinks
        self.authService = authenticationService
        self.trailerService = trailerService
    }
    
    public var isAuthenticated : Bool {
        return currentAuthToken != nil
    }
    
    public var authenticatedUserFullName : String {
        if let token = currentAuthToken {
            if let displayName = token.displayName {
                return displayName
            } else {
                // TODO(rgrimm): Localize this string
                return "Unknown Name"
            }
        } else {
            // TODO(rgrimm): Localize this string
            return "Unauthenticated User"
        }
    }
    
    public var authenticatedUserEmail : String? {
        return currentAuthToken?.email
    }
    
    private func setAnalyticsInfo() {
        analyticsManager?.activeUserIdentifier = currentAuthToken?.value
        analyticsManager?.activeUserFullName = authenticatedUserFullName
        analyticsManager?.activeUserEmail = authenticatedUserEmail
    }
    
    public func performLogin(#username : String, password : String, handler : ((success : Bool, message : String?) -> Void)?) {
        
        authService.getToken(availableLinks, username: username, password: password) { (token, nextLinks, message) -> Void in
            if let links = nextLinks {
                self.availableLinks = links
            }
            
            if let unwrappedToken = token {
                self.currentAuthToken = unwrappedToken
            } else {
                self.currentAuthToken = nil
            }
            
            handler?(success: self.isAuthenticated, message: message)
        }

    }
    
    public func performLogout(handler : ((success : Bool, message : String?) -> Void)?) {
        
        availableLinks = initialLinks
        
        currentAuthToken = nil
        
        handler?(success: !self.isAuthenticated, message: "OK")
        
    }
    
    public func getTrailerByTrailerNumberAndLastSixVin(#trailerNumber : String, lastSixVin : String, handler : ((trailer : Trailer?, message : String) -> Void)?) {
        if let token = currentAuthToken {
            trailerService.getTrailerByTrailerNumberAndLastSixVin(token: token, links: availableLinks, trailerNumber: trailerNumber, lastSixVin: lastSixVin) { (trailer, nextLinks, message) -> Void in
                if let links = nextLinks {
                    self.availableLinks = links
                }
                
                handler?(trailer: trailer, message: message)
            }
        } else {
            #if DEBUG
                WernerLog("Attempting to call getTrailer before obtaining a token; crashing...")
                abort()
            #else
                WernerLog("Attempting to call getTrailer before obtaining a token; cancelling call...")
                // TODO(rgrimm): Localize the message
                handler?(trailer: nil, message: "Login data lost; please try logging in again.")
            #endif
        }
    }

    public class Support {
        public class func mapLinks(links : [String : String]?) -> [String : NSURL]? {
            var output : [String : NSURL]?
            
            if let links = links where !links.isEmpty {
                output = [:]
                for key in links.keys {
                    output![key] = NSURL(string: links[key]!)
                }
            }
            
            return output
        }
        
        public class func mapLinks(links : [String : String]?, relativeToUrl url : NSURL) -> [String : NSURL]? {
            var output : [String : NSURL]?
            
            if let links = links where !links.isEmpty {
                output = [:]
                for key in links.keys {
                    output![key] = NSURL(string: links[key]!, relativeToURL: url)
                }
            } else {
                output = nil
            }
            
            return output
        }
    }

}
