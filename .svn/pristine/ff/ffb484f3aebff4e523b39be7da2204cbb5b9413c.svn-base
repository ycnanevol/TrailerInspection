//
//  InspectionTriStateDamageCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-06.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionTriStateDamageCell : InspectionDamageCellBase {
    
    // MARK: InspectionTriStateDamageCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, segmentTitles : [String?] = [], changeHandler : ((changeType : ChangeType, sender : InspectionTriStateDamageCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            self.segmentTitles = segmentTitles

            self.handler = changeHandler
        }
        
        var labelText : String!
        var segmentTitles : [String?] = []
        
        var selectedSegment = UISegmentedControlNoSegment
        var damageSet : Set<InspectionDamageType>!
        var pictures : [UIImage]!
        
        var handler : ((ChangeType, InspectionTriStateDamageCell) -> Void)?
        
        public override func validate() -> Bool {
            return selectedSegment != UISegmentedControlNoSegment
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable : InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("TriStateDamageCell", forIndexPath: indexPath) as! InspectionTriStateDamageCell
            
            cell.inspectionTableController = inspectionTable
            cell.state = self

            cell.cellLabel.text = labelText
            
            for index in indices(segmentTitles) {
                if let title = segmentTitles[index] {
                    cell.damageSegmentControl.setTitle(title, forSegmentAtIndex: index)
                } else {
                    segmentTitles[index] = cell.damageSegmentControl.titleForSegmentAtIndex(index)
                }
            }
            
            for var index = segmentTitles.endIndex; index < cell.damageSegmentControl.numberOfSegments; index++ {
                segmentTitles.append(cell.damageSegmentControl.titleForSegmentAtIndex(index))
            }
            
            cell.damageSegmentControl.selectedSegmentIndex = selectedSegment
            if damageSet != nil {
                cell.damageSet = damageSet
                cell.pictures = pictures
            }
            
            cell.damageDetailButton.hidden = cell.damageState != .Damage
            cell.damageDetailButton.enabled = !cell.damageDetailButton.hidden
            
            return cell
        }
    }

    public typealias ChangeType = InspectionTriStateData

    // MARK: InspectionTriStateDamageCell members
    @IBOutlet weak var damageSegmentControl : UISegmentedControl!
    
    enum State : Int {
        case OK = 0, NA, Damage
    }
    
    var damageState : State? {
        get {
            return State(rawValue: damageSegmentControl.selectedSegmentIndex)
        }
    }
    
    weak var state : CellState!
    
    func setDetailButtonVisibility(visible : Bool) {
        damageDetailButton.enabled = visible
        
        UIView.animateWithDuration(Constants.animationDuration) { () -> Void in
            self.damageDetailButton.hidden = !visible
        }
    }
    
    func callChangeHandler() {
        let changeType : ChangeType
        
        switch damageState! {
        case .OK: changeType = .OK
        case .NA: changeType = .NA
        case .Damage: changeType = .Damaged(damages: damageSet, pictures: pictures)
        }
        
        state.handler?(changeType, self)
    }
    
    @IBAction func segmentValueDidChange() {
        state.selectedSegment = damageSegmentControl.selectedSegmentIndex
        
        if let state = self.damageState {
            switch state {
            case .OK:
                fallthrough
            case .NA:
                damageSet.removeAll(keepCapacity: true)
                pictures.removeAll(keepCapacity: true)
                setDetailButtonVisibility(false)
                callChangeHandler()
            case .Damage:
                setDetailButtonVisibility(true)
                performDamageDetailSegue()
            }
        }
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionTriStateDamageCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    public func getValidationFailureViews() -> [UIView] {
        if damageSegmentControl?.selectedSegmentIndex == UISegmentedControlNoSegment {
            return [damageSegmentControl]
        }
        
        return []
    }
    
}


// MARK: - InspectionSegueDelegate extension
extension InspectionTriStateDamageCell : InspectionSegueDelegate {
    
    public override func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        super.prepareForUnwindSegue(segue)
        
        if let damageSource = segue.sourceViewController as? PopupDamageDetailsViewController {
            state.damageSet = damageSet
            state.pictures = pictures
            
            if damageSet.isEmpty {
                state.selectedSegment = UISegmentedControlNoSegment
                damageSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
                setDetailButtonVisibility(false)
            }
            
            if segue.identifier == "DamageSaveUnwindSegue" && state.selectedSegment != UISegmentedControlNoSegment {
                callChangeHandler()
            }
        }
    }
    
}
