//
//  ViewControllerBase.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import UIKit
import CoreData


public class ViewControllerBase : UIViewController {
    
    lazy var appDelegate : AppDelegate! = {
        let application = UIApplication.sharedApplication()
        return application.delegate as! AppDelegate
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext! = {
        return self.appDelegate.managedObjectContext
    }()
    
    private var _serviceManager : ServiceManager!
    var serviceManager : ServiceManager {
        get {
            if _serviceManager == nil {
                WernerLog("ServiceManager not provided; building with default request manager.")
                _serviceManager = ServiceManagerFactory.buildDefaultUsingRequestManager(appDelegate.defaultRequestManager)
                _serviceManager.analyticsManager = appDelegate.analyticsManager
            }
            
            return _serviceManager
        }
        set {
            _serviceManager = newValue
        }
    }
    
    var _toolbarItems : [UIBarButtonItem]!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if _toolbarItems != nil {
            toolbarItems = _toolbarItems
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        var destination : ViewControllerBase? = segue.destinationViewController as? ViewControllerBase
        
        destination?._toolbarItems = _toolbarItems
        
        if let navControllerDestination = segue.destinationViewController as? UINavigationController where navControllerDestination.viewControllers?.count > 0 {
            destination = navControllerDestination.viewControllers[0] as? ViewControllerBase
        }
        
        
        destination?._serviceManager = _serviceManager
    }
    
}
