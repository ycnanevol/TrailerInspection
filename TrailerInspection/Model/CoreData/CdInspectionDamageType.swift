//
//  CdInspectionDamageType.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 12/6/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import CoreData
@objc(CdInspectionDamageType)
class CdInspectionDamageType: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var inspectionTriStateData: CdInspectionTriStateData

}
