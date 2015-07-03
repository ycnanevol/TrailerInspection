//
//  Token.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class Token {
    
    public init() {}
    
    public convenience init(value : String) {
        self.init()
        self.value = value
    }
    
    public convenience init(value : String, displayName : String, email : String) {
        self.init()
        self.value = value
        self.displayName = displayName
        self.email = email
    }
    
    public var value : String = ""
    public var displayName : String?
    public var email : String?

}

extension Token : Equatable {}

extension Token : Printable {
    
    public var description : String {
        let out : String
        
        if let displayName = self.displayName,
            let email = self.email {
                out = "\(displayName) (\(email); \(value))"
        } else if let displayName = self.displayName {
            out = "\(displayName) (\(value))"
        } else if let email = self.email {
            out = "\(email) (\(value))"
        } else {
            out = value
        }
        
        return out
    }
    
}

public func ==(lhs : Token, rhs : Token) -> Bool {
    if lhs.value != rhs.value {
        return false
    }
    
    return true
}
