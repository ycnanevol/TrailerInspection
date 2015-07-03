//
//  CdSealImage.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 12/6/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import CoreData
@objc(CdSealImage)
class CdSealImage: NSManagedObject {

    @NSManaged var data: NSData
    @NSManaged var sealData: CdSealData
    
    @NSManaged var identity: String

}
