//
//  InspectionBackgroundService.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 23/6/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

public class InspectionBackgroundService {
    
    public var postInspectionTask : UIBackgroundTaskIdentifier!
    public static var unpostedInspections: [String] = []
    public static var postedInspections: [String] = []
    
    public func startupTrailerInspectionBackgroundService() {
        
//        postInspectionTask = UIApplication.sharedApplication().beginBackgroundTaskWithName("PostInspectionToServer", expirationHandler: { () -> Void in
//            
//            UIApplication.sharedApplication().endBackgroundTask(self.postInspectionTask)
//            self.postInspectionTask = UIBackgroundTaskInvalid
//        })
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            
//            
//            
//            UIApplication.sharedApplication().endBackgroundTask(self.postInspectionTask)
//            self.postInspectionTask = UIBackgroundTaskInvalid;
//            
//        });
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("sendInspectionToServer"), userInfo: nil, repeats: true)
    }
    
    @objc public func sendInspectionToServer() {
        
        println("Task is calling.......")
		
        var error: NSError? = nil
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Inspection")
        fetchRequest.returnsObjectsAsFaults = false
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var inspections = appDelegate.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        for (index, inspection) in enumerate(inspections!)  {
            
            var item: CdInspection = inspection as! CdInspection
            let attributeNames: [String] = item.entity.properties as! [String]
            let itemJson: JSON = JSON(item)
            println(itemJson.description)
        }
    }
    
    func getInspectionByDocumentNumber(docNumber: String) -> CdInspection? {
        
        let inspectionEntity: CdInspection?
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var error: NSError? = nil
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Inspection")
        fetchRequest.returnsObjectsAsFaults = false
        
        var inspections = appDelegate.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        for (index, inspection) in enumerate(inspections!)  {
            
            var item = inspection as! CdInspection
            
            return item
        }
        return nil
    }
}