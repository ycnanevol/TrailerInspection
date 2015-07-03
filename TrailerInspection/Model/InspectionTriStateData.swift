//
//  InspectionTriStateData.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public enum InspectionTriStateData {
    case OK
    case NA
    case Damaged(damages : Set<InspectionDamageType>, pictures : [UIImage])
    
    public func hasDamagedPictures() -> Bool {
        
        switch self {
        case let .Damaged(damageSet, pictures):
            #if DEBUG
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    return !pictures.isEmpty
                } else {
                    // Simulator doesn't have camera, so in DEBUG mode, show picture icons anyway
                    return !pictures.isEmpty || !damageSet.isEmpty
                }
            #else
                return !pictures.isEmpty
            #endif
        default : return false
        }
        
    }
    
}

extension InspectionTriStateData : Equatable {}

extension InspectionTriStateData : Printable {
    
    public var description : String {
        switch self {
        // TODO(jjiang) to get the printable values from NSLocalizedString()
        case .OK : return "OK"
        case .NA : return "N/A"
        case .Damaged : return "Damaged"
        }
    }

}

public func ==(lhs : InspectionTriStateData, rhs : InspectionTriStateData) -> Bool {
    switch (lhs, rhs) {
    case (.OK, .OK):
        fallthrough
    case (.NA, .NA):
        fallthrough
    case (.Damaged, .Damaged):
        return true
    default:
        return false
    }
}
