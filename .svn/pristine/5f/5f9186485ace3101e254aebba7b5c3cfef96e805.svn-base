//
//  TriStateBool.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

// Using "nil" as a 3rd state is messy and crash-prone; instead, this enum offers an explicit 3rd state
public enum TriStateBool {
    case True
    case Unknown
    case False
}

extension TriStateBool {
    public init(_ value : BooleanType) {
        self = value.boolValue ? .True : .False
    }
}

extension TriStateBool : BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = value ? .True : .False
    }
}

extension TriStateBool : BooleanType {
    public var boolValue : Bool {
        switch self {
        case .True: return true
        default: return false
        }
    }
}

extension TriStateBool : Printable {
    public var description : String {
        switch self {
        case .True: return "True"
        case .Unknown: return "Unknown"
        case .False: return "False"
        }
    }
}

extension TriStateBool : Equatable {}

public func ==(lhs : TriStateBool, rhs : TriStateBool) -> Bool {
    switch (lhs, rhs) {
    case (.True, .True): return true
    case (.Unknown, .Unknown): return true
    case (.False, .False): return true
    default: return false
    }
}

public prefix func !(value : TriStateBool) -> TriStateBool {
    switch value {
    case .True: return .False
    case .Unknown: return .Unknown
    case .False: return .True
    }
}
