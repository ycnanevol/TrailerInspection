//
//  Company.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-10.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public struct Company {
    public var id : Int?
    public var code : String?
    public var name : String
}

extension Company : Equatable {}

public func ==(lhs : Company, rhs : Company) -> Bool {
    if lhs.id != nil || rhs.id != nil {
        return lhs.id == rhs.id
    }
    
    if lhs.code != nil || rhs.code != nil {
        return lhs.code == rhs.code
    }
    
    return lhs.name == rhs.name
}
