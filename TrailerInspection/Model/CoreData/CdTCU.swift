//
//  CdTCU.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 12/6/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(CdTCU)
class CdTCU: NSManagedObject {

    @NSManaged var airChute: String
    @NSManaged var belts: String
    @NSManaged var bulkHeads: String
    @NSManaged var currentTemperatureFahrenheit: NSNumber
    @NSManaged var eTrack: String
    @NSManaged var fuelLevel: NSNumber
    @NSManaged var grill: String
    @NSManaged var hoses: String
    @NSManaged var insepctionId: NSNumber
    @NSManaged var isAntiFreezeLow: String
    @NSManaged var isOilLow: String
    @NSManaged var lowerDoors: String
    @NSManaged var setTemperatureFahrenheit: NSNumber
    @NSManaged var upperDoors: String
    @NSManaged var inspection: CdInspection

}
