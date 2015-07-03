//
//  AuthenticationService.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class AuthenticationService {
    
    var requestManager : Manager
    
    public init(requestManager : Manager!) {
        self.requestManager = requestManager
    }
    
    public convenience init() {
        self.init(requestManager: Manager(configuration: nil))
    }
    
    public func getToken(links : [String : NSURL], username : String, password : String, handler : (token : Token?, nextLinks : [String : NSURL]?, message : String) -> Void) {
        if let getTokenUrl = links["getToken"] {
            
            var request = NSMutableURLRequest(URL: getTokenUrl)
            
            // TODO(rgrimm): Authentication service should make sure to use X- to indicate non-standard headers
            request.setValue(request.valueForHTTPHeaderField("X-Werner-AppVersion"), forHTTPHeaderField: "AppVersion")
            request.setValue(request.valueForHTTPHeaderField("X-Werner-DeviceID"), forHTTPHeaderField: "DeviceId")
            
            // TODO(rgrimm): Get a better authentication service
            request.setValue(username, forHTTPHeaderField: "UserId")
            request.setValue(password, forHTTPHeaderField: "Password")
            
            requestManager.request(request).responseJSON { (request, response, data, error) -> Void in
                var token : Token?
                var nextLinks : [String : String]?
                var message : String
                
                // TODO(rgrimm): Handle error object more gracefully
                
                if let data : AnyObject = data {
                    (token, nextLinks, message) = self.parseGetTokenResponse(response: response, data: JSON(data))
                } else {
                    message = NSLocalizedString("UnrecognizedResponse", tableName: "ServiceResponses", bundle: .mainBundle(), value: "Unrecognized response from service call", comment: "The error message to display when a service returns a value but it is not in a recognized format")
                }
                
                handler(token: token, nextLinks: ServiceManager.Support.mapLinks(nextLinks, relativeToUrl: getTokenUrl), message: message)
            }
        
        } else {

            handler(token: nil, nextLinks: nil, message: "getToken link not available!")

        }
    }
    
    func parseGetTokenResponse(#response : NSHTTPURLResponse!, data : JSON) -> (Token?, [String : String]?, String) {
        var nextLinks : [String : String]?
        if let links = data["links"].dictionaryObject as? [String : String] {
            nextLinks = links
        } else {
            nextLinks = nil
        }
        
        if response.statusCode != 200 {
            if let message = data["message"].string {
                return (nil, nextLinks, message)
            } else {
                let errorMessageFormat = NSLocalizedString("NoErrorMessageOnNonSuccessCode", tableName: "ServiceResponses", bundle: .mainBundle(), value: "The server response did not indicate success and did not include an error message. (HTTP code %@)", comment: "The message to display when a service call does not include a message in its response.")
                
                return (nil, nextLinks, String(format: errorMessageFormat, "\(response.statusCode)"))
            }
        }
        
        var token = Token()
        token.value = data["value"].stringValue
        token.email = data["email"].string
        token.displayName = data["displayName"].string
        
        if let message = data["message"].string {
            return (token, nextLinks, message)
        } else {
            return (token, nextLinks, NSLocalizedString("NoSuccessMessage", tableName: "ServiceResponses", bundle: .mainBundle(), value: "OK", comment: "The message to display when a service call is successful and did not include a message in its response."))
        }
    }
    
}

#if DEBUG
    class AuthenticationDebugService : AuthenticationService {
        override func getToken(links : [String : NSURL], username: String, password: String, handler: (token: Token?, nextLinks : [String : NSURL]?, message: String) -> Void) {
            if let getTokenUrl = links["getToken"] {
                let nextLinks : [String : String] = [
                    "getToken": getTokenUrl.description,
                    "getTrailer": "http://dev-sb13-mt1.wernerds.net:8080/logistics/services/equipment/v1/trailer",
                ]
                var token = Token(value: "Dummy Token")
                
                handler(token: token, nextLinks: ServiceManager.Support.mapLinks(nextLinks, relativeToUrl: getTokenUrl), message: "OK")
            } else {
                handler(token: nil, nextLinks: nil, message: "getToken link not available!")
            }
        }
    }
#endif
