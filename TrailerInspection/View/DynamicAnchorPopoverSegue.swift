//
//  DynamicAnchorPopoverSegue.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-07.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class DynamicAnchorPopoverSegue : UIStoryboardPopoverSegue {
    
    public var delegate : DynamicAnchorPopoverSegueDelegate?
  
    public override init!(identifier: String!, source: UIViewController, destination: UIViewController) {
        delegate = source as? DynamicAnchorPopoverSegueDelegate
        
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    public override func perform() {
        if let source = sourceViewController as? UIViewController,
            let destination = destinationViewController as? UIViewController {
                
                if source.traitCollection.userInterfaceIdiom != .Pad {
                    source.presentViewController(destination, animated: true, completion: nil)
                    return
                }
                
                if (popoverController.popoverVisible) {
                    popoverController.dismissPopoverAnimated(true)
                    return
                }
                
                var view : UIView
                
                if let dynamicView = delegate?.dynamicAnchorViewForSegue(self) {
                    view = dynamicView
                } else {
                    view = (sourceViewController as! UIViewController).view
                }
                
                if let unwrappedDelegate = delegate {
                    popoverController.presentPopoverFromRect(unwrappedDelegate.dynamicAnchorRectForSegue(self), inView: view, permittedArrowDirections: .Any, animated: true)
                }
        }
    }
}

@objc public protocol DynamicAnchorPopoverSegueDelegate {
    func dynamicAnchorRectForSegue(segue : DynamicAnchorPopoverSegue) -> CGRect
    func dynamicAnchorViewForSegue(segue : DynamicAnchorPopoverSegue) -> UIView?
}
