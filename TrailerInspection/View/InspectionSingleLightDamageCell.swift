//
//  InspectionSingleLightDamageCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-06.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionSingleLightDamageCell : InspectionDamageCellBase {
    
    // MARK: InspectionSingleLightDamageCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, changeHandler : ((changeType : ChangeType, sender : InspectionSingleLightDamageCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            
            self.handler = changeHandler
        }
        
        var labelText : String!
        
        var selectedTypeSegment = UISegmentedControlNoSegment
        var selectedDamageSegment = UISegmentedControlNoSegment
        var damageSet : Set<InspectionDamageType>!
        var pictures : [UIImage]!
        
        var handler : ((ChangeType, InspectionSingleLightDamageCell) -> Void)?
        
        public override func validate() -> Bool {
            if selectedDamageSegment == UISegmentedControlNoSegment {
                return false
            }
            
            // When N/A is selected, the type isn't required any more
            if selectedDamageSegment != 1 && selectedTypeSegment == UISegmentedControlNoSegment {
                return false
            }
            
            return true
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("SingleLightDamageCell", forIndexPath: indexPath) as! InspectionSingleLightDamageCell
            
            cell.inspectionTableController = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText
            
            cell.lightTypeSegmentControl.selectedSegmentIndex = selectedTypeSegment
            cell.damageSegmentControl.selectedSegmentIndex = selectedDamageSegment
            if damageSet != nil {
                cell.damageSet = damageSet
                cell.pictures = pictures
            }
            
            cell.damageDetailButton.hidden = cell.damageState != .Damage
            cell.damageDetailButton.enabled = !cell.damageDetailButton.hidden
            
            return cell
        }
        
    }
    
    public enum DamageState : Int {
        case OK = 0, NA, Damage
    }
    
    public enum LightType : Int {
        case LED = 0
        case Filament
    }
    
    public enum ChangeType {
        case LightType(value : InspectionSingleLightDamageCell.LightType?)
        case Damage(damageType : InspectionTriStateData)
    }
    
    // MARK: InspectionSingleLightDamageCell members
    @IBOutlet weak var lightTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var damageSegmentControl : UISegmentedControl!
    
    var damageState : DamageState? {
        get {
            return DamageState(rawValue: damageSegmentControl.selectedSegmentIndex)
        }
    }
    
    weak var state : CellState!
    
    func setDetailButtonVisibility(visible : Bool) {
        damageDetailButton.enabled = visible
        
        UIView.animateWithDuration(Constants.animationDuration) { () -> Void in
            self.damageDetailButton.hidden = !visible
        }
    }
    
    func callDamageChangeHandler() {
        let damageType : InspectionTriStateData
        
        switch damageState! {
        case .OK: damageType = .OK
        case .NA:
            // When N/A is selected, unset light type
            state.handler?(.LightType(value: nil), self)
            damageType = .NA
        case .Damage: damageType = .Damaged(damages: damageSet, pictures: pictures)
        }
        
        state.handler?(.Damage(damageType : damageType), self)
    }
    
    @IBAction func segmentValueDidChange(sender : UISegmentedControl) {
        switch sender {
        case lightTypeSegmentControl:
            state.selectedTypeSegment = sender.selectedSegmentIndex
            
            if damageState == .NA {
                state.selectedDamageSegment = UISegmentedControlNoSegment
                damageSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
            }
            
            if let lightType = LightType(rawValue: sender.selectedSegmentIndex) {
                state.handler?(.LightType(value: lightType), self)
            }
        case damageSegmentControl:
            state.selectedDamageSegment = sender.selectedSegmentIndex
            
            if let state = self.damageState {
                switch state {
                case .OK:
                    damageSet.removeAll(keepCapacity: true)
                    pictures.removeAll(keepCapacity: true)
                    setDetailButtonVisibility(false)
                    callDamageChangeHandler()
                case .NA:
                    self.state.selectedTypeSegment = UISegmentedControlNoSegment
                    lightTypeSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
                    damageSet.removeAll(keepCapacity: true)
                    pictures.removeAll(keepCapacity: true)
                    setDetailButtonVisibility(false)
                    callDamageChangeHandler()
                case .Damage:
                    setDetailButtonVisibility(true)
                    performDamageDetailSegue()
                }
            }
        default:
            WernerLog("Unknown segmented control called InspectionSingleLightDamageCell::segmentValueDidChange()")
        }
    }
    
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionSingleLightDamageCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return getValidationFailureViews().isEmpty
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        if damageState != .NA && lightTypeSegmentControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(lightTypeSegmentControl)
        }
        
        if damageSegmentControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(damageSegmentControl)
        }
        
        return failedViews
    }
    
}

// MARK: - InspectionSegueDelegate extension
extension InspectionSingleLightDamageCell : InspectionSegueDelegate {
    
    public override func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        super.prepareForUnwindSegue(segue)
        
        if let damageSource = segue.sourceViewController as? PopupDamageDetailsViewController {
            state.damageSet = damageSet
            state.pictures = pictures
            
            if damageSet.isEmpty {
                state.selectedDamageSegment = UISegmentedControlNoSegment
                damageSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
                setDetailButtonVisibility(false)
            }
            
            if segue.identifier == "DamageSaveUnwindSegue" && state.selectedDamageSegment != UISegmentedControlNoSegment {
                callDamageChangeHandler()
            }
        }
    }
    
}
