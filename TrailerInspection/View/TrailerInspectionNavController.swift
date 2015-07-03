//
//  TrailerInspectionNavController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-16.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class TrailerInspectionNavController : UINavigationController {
    
    lazy var appDelegate : AppDelegate! = {
        let application = UIApplication.sharedApplication()
        return application.delegate as! AppDelegate
    }()
    
    lazy var serviceManager : ServiceManager! = {
        WernerLog("ServiceManager not provided; building with default request manager.")
        var serviceManager = ServiceManagerFactory.buildDefaultUsingRequestManager(self.appDelegate.defaultRequestManager)
        serviceManager.analyticsManager = self.appDelegate.analyticsManager
        
        return serviceManager
    }()
    
    // MARK: - Toolbar Items
    
    lazy var profilePicToolbarButton : UIBarButtonItem = {
        let image = UIImage(named: "In-App-Icon-User")
        
        let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        buttonView.setImage(image, forState: .Normal)
        
        buttonView.addTarget(self, action: "profileButtonDidClick", forControlEvents: .TouchUpInside)
        
        let button = UIBarButtonItem(customView: buttonView)
        button.width = 28
        
        return button
    }()

    lazy var profileNameToolbarButton : UIBarButtonItem! = {
        let button = UIBarButtonItem(title: "Joe User", style: .Plain, target: self, action: "profileButtonDidClick")
        
        button.width = 100
        button.setTitleTextAttributes([NSFontAttributeName: self.statusTextLabel.font.fontWithSize(14)], forState: UIControlState.Normal)
        
        return button
    }()
    
    var statusTextLabel : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 300, 44))
        
        label.text = "Status Text"
        label.textColor = UIColor.blackColor()
        label.font = label.font.fontWithSize(14)
        label.numberOfLines = 1
        label.textAlignment = .Center
        label.autoresizingMask = .FlexibleWidth | .FlexibleLeftMargin | .FlexibleRightMargin
        label.hidden = true
        
        return label
    }()
    
    var statusText : String? {
        get {
            return statusTextLabel.text
        }
        set {
            if newValue == nil || newValue!.isEmpty {
                statusTextLabel.hidden = true
            } else {
                statusTextLabel.hidden = false
                statusTextLabel.text = newValue
            }
        }
    }
    
    lazy var defaultToolbarItems : [UIBarButtonItem] = {
        let iconTextSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        iconTextSpacer.width = 8
        
        let rightSideSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)

        var items : [UIBarButtonItem] = [
            self.profilePicToolbarButton,
            iconTextSpacer,
            self.profileNameToolbarButton,
        ]
        
        rightSideSpacer.width = items.reduce(CGFloat(0)) { (width : CGFloat, barButtonItem : UIBarButtonItem) -> CGFloat in
            width + barButtonItem.width
        }
        
        items += [
            flexibleSpacer,
            UIBarButtonItem(customView: self.statusTextLabel),
            flexibleSpacer,
            rightSideSpacer,
        ]
        
        for item in items {
            item.tintColor = self.navigationBar.tintColor
        }
        
        return items
    }()
    
    // MARK: - View Handling
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootController = viewControllers.last as? ViewControllerBase {
            rootController.serviceManager = serviceManager
            rootController._toolbarItems = defaultToolbarItems
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !serviceManager.isAuthenticated {
            performSegueWithIdentifier("LoginSegue", sender: self)
            return ()
        }
        
        profileNameToolbarButton.title = serviceManager.authenticatedUserFullName
    }
    
    // MARK: - Navigation
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        var destination : ViewControllerBase? = segue.destinationViewController as? ViewControllerBase
        
        if let navControllerDestination = segue.destinationViewController as? UINavigationController where navControllerDestination.viewControllers?.count > 0 {
            destination = navControllerDestination.viewControllers[0] as? ViewControllerBase
        }
        
        
        destination?.serviceManager = serviceManager
    }
    
    // MARK: - Toolbar Actions
    
    func profileButtonDidClick() {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.popoverPresentationController?.barButtonItem = profileNameToolbarButton
        
        if let rootController = viewControllers.last as? ProfileMenuDataSource {
            for alertAction in rootController.additionalProfileMenuItems {
                alertController.addAction(alertAction)
            }
        }
        
        #if DEBUG
            alertController.addAction(UIAlertAction(title: "Simulate Crash", style: .Default) { (alertAction) -> Void in
                self.appDelegate.analyticsManager.simulateCrash()
            })
        #endif
        
        // TODO(rgrimm): Localize the title
        alertController.addAction(UIAlertAction(title: "Logout", style: .Default) { (alertAction) -> Void in
            self.serviceManager.performLogout { (success, message) -> Void in
                WernerLog("Logout message: \(message)")
                self.performSegueWithIdentifier("LoginSegue", sender: self)
            }
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

public protocol ProfileMenuDataSource {
    
    var additionalProfileMenuItems : [UIAlertAction] {
        get
    }
    
}
