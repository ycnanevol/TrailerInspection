//
//  CdSealData.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 12/6/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import CoreData
@objc(CdSealData)
class CdSealData: NSManagedObject {

    @NSManaged var sealNumber: String
    @NSManaged var sealType: String
    @NSManaged var images: NSMutableSet

    @NSManaged var inspection: CdInspection
}
