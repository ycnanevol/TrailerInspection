//
//  InspectionDamageCellBase.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-06.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionDamageCellBase : UITableViewCell {
    
    static let promptFormat = NSLocalizedString("DamagePopoverPrompt", tableName: "DamagePopover", bundle: .mainBundle(), value: "%@ Details", comment: "Formatted text for the navigation prompt text in the damage popover")
    
    @IBOutlet weak var cellLabel : UILabel!
    @IBOutlet weak var damageDetailButton : UIButton!
    
    weak var inspectionTableController : InspectionTableViewController!
    
    var damageSet = Set<InspectionDamageType>()
    public var pictures = [UIImage]()
    
    @IBAction public func performDamageDetailSegue() {
        inspectionTableController.popoverAnchor = damageDetailButton
        inspectionTableController.popoverSegueDelegate = self
        inspectionTableController.performSegueWithIdentifier("DamageDetailSegue", sender: self)
    }
}

extension InspectionDamageCellBase : InspectionSegueDelegate {
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let damageDestination = segue.destinationViewController as? PopupDamageDetailsViewController {
            
            if let baseText = cellLabel.text {
                damageDestination.promptText = String(format: InspectionDamageCellBase.promptFormat, baseText)
            }
            
            damageDestination.damageState = (damages: damageSet, pictures: pictures)
        }
    }
    
    public func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "DamageSaveUnwindSegue",
            let damageSource = segue.sourceViewController as? PopupDamageDetailsViewController {
                (damageSet, pictures) = damageSource.damageState
        }
    }
    
}
