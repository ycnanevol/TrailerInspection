//
//  InspectionMultiLightDamageCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-06.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionMultiLightDamageCell : InspectionDamageCellBase {
    
    // MARK: InspectionMultiLightDamageCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, maxLights : Int = 5, changeHandler : ((changeType : ChangeType, sender : InspectionMultiLightDamageCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            self.maxLights = maxLights
            
            self.handler = changeHandler
        }
        
        var labelText : String!
        var maxLights = 5
        
        var selectedTypeSegment = UISegmentedControlNoSegment
        var numLights = UISegmentedControlNoSegment + 1
        var hasDamage : Bool = false
        var damageSet : Set<InspectionDamageType>!
        var pictures : [UIImage]!
        
        var hasCalledWithInitialDamageState = false
        var handler : ((ChangeType, InspectionMultiLightDamageCell) -> Void)?
        
        public override func validate() -> Bool {
            if selectedTypeSegment == UISegmentedControlNoSegment {
                return false
            }
            
            if numLights == 0 {
                return false
            }
            
            return true
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("MultiLightDamageCell", forIndexPath: indexPath) as! InspectionMultiLightDamageCell
            
            cell.inspectionTableController = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText
            
            cell.lightTypeSegmentControl.selectedSegmentIndex = selectedTypeSegment
            cell.numLightsSegmentControl.selectedSegmentIndex = numLights - 1
            
            cell.damageToggleButton.selected = hasDamage
            if damageSet != nil {
                cell.damageSet = damageSet
                cell.pictures = pictures
            }

            cell.damageDetailButton.hidden = !hasDamage
            cell.damageDetailButton.enabled = hasDamage
            
            // Call handler if damage state hasn't been set yet
            // TODO(rgrimm): Fix this so the cell doesn't have to display in order to set the value
            if !hasCalledWithInitialDamageState {
                handler?(.Damage(value: .OK), cell)
                hasCalledWithInitialDamageState = true
            }
            
            return cell
        }
    }
    
    public enum LightType : Int {
        case LED = 0
        case Filament
    }
    
    public enum ChangeType {
        case LightType(value : InspectionMultiLightDamageCell.LightType)
        case NumLights(value : Int)
        case Damage(value : InspectionTriStateData)
    }

    // MARK: InspectionMultiLightDamageCell members
    @IBOutlet weak var lightTypeSegmentControl : UISegmentedControl!
    @IBOutlet weak var numLightsSegmentControl : UISegmentedControl!
    @IBOutlet weak var damageToggleButton : UIButton!
    
    weak var state : InspectionMultiLightDamageCell.CellState!
    
    func setDamageState(hasDamage : Bool, animated : Bool) {
        damageToggleButton.selected = hasDamage
        state.hasDamage = hasDamage
        damageDetailButton.enabled = hasDamage
        
        UIView.animateWithDuration(Constants.animationDuration) { () -> Void in
            self.damageDetailButton.hidden = !hasDamage
        }
        
        if !hasDamage {
            damageSet.removeAll(keepCapacity: true)
            pictures.removeAll(keepCapacity: true)
        }
    }
    
    @IBAction func toggleDamage(sender : UIButton) {
        setDamageState(!state.hasDamage, animated: true)
        
        if state.hasDamage {
            performDamageDetailSegue()
        }
    }
    
    @IBAction func segmentValueDidChange(sender : UISegmentedControl) {
        switch sender {
        case lightTypeSegmentControl:
            state.selectedTypeSegment = sender.selectedSegmentIndex
            state.handler?(.LightType(value: LightType(rawValue: state.selectedTypeSegment)!), self)
        case numLightsSegmentControl:
            state.numLights = sender.selectedSegmentIndex + 1
            state.handler?(.NumLights(value: state.numLights), self)
        default:
            WernerLog("Unknown segmented control called InspectionMultiLightDamageCell::segmentValueDidChange()")
        }
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionMultiLightDamageCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return getValidationFailureViews().isEmpty
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        if lightTypeSegmentControl?.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(lightTypeSegmentControl)
        }
        
        if numLightsSegmentControl?.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(numLightsSegmentControl)
        }
        
        return failedViews
    }
    
}

// MARK: - InspectionSegueDelegate extension
extension InspectionMultiLightDamageCell : InspectionSegueDelegate {
    
    public override func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        super.prepareForUnwindSegue(segue)
        
        if let damageSource = segue.sourceViewController as? PopupDamageDetailsViewController {
            state.damageSet = damageSet
            state.pictures = pictures
            
            if damageSet.isEmpty {
                setDamageState(false, animated: true)
            }
            
            if segue.identifier == "DamageSaveUnwindSegue" {
                let changeType : ChangeType
                
                if state.hasDamage {
                    changeType = .Damage(value: .Damaged(damages: damageSet, pictures: pictures))
                } else {
                    changeType = .Damage(value: .OK)
                }
                
                state.handler?(changeType, self)
            }
        }
    }
    
}
