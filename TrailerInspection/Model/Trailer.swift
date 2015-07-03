//
//  Trailer.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class Trailer : NSObject {
    // This needs a witty comment about the similarity in file name to a certain well-known singer name.
        
    var trailerNumber : String!
    var trailerType : TrailerType = .Unknown
    
    var licenseNumber : String!
    var licenseState : String!
    
    var owner : String!
    var vin : String!
    
    var isLoaded : TriStateBool = .Unknown
    var isAeroSkirtEquipped : TriStateBool = .Unknown
    var isPsiEquipped : TriStateBool = .Unknown
    var isGpsEquipped : TriStateBool = .Unknown
    
    var numberOfAxles : NSNumber!
    var heightInFeet : NSNumber!
    var lengthInFeet : NSNumber!
    
    var make : String!
    var model : String!
    var modelYear : String!

}
