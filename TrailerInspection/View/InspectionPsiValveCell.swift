//
//  InspectionPsiValveCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-14.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionPsiValveCell : UITableViewCell {
    
    static let localizedOpenValveTitle = NSLocalizedString("PleaseOpenValve", tableName: "InspectionTable", bundle: .mainBundle(), value: "Please Open PSI Valve", comment: "Title for the alert that asks the inspector to open the valve if it is closed")
    static let localizedOkAction = NSLocalizedString("OkAction", tableName: "InspectionTable", bundle: .mainBundle(), value: "OK", comment: "Only button for alert that prompts user to open the PSI valve")
    
    // MARK: InspectionPsiValveCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, changeHandler : ((changeType : ChangeType, sender : InspectionPsiValveCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            
            self.handler = changeHandler
        }
        
        var labelText : String!
        
        var selectedSegment = UISegmentedControlNoSegment
        
        var handler : ((ChangeType, InspectionPsiValveCell) -> Void)?
        
        public override func validate() -> Bool {
            return selectedSegment == ChangeType.Open.rawValue
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("PsiValveCell", forIndexPath: indexPath) as! InspectionPsiValveCell
            
            cell.inspectionTable = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText
            
            return cell
        }
        
    }
    
    public enum ChangeType : Int {
        case Open = 0
        case Closed
    }
    
    // MARK: InspectionPsiValveCell members
    @IBOutlet weak var cellLabel : UILabel!
    @IBOutlet weak var openOrClosedSegmentControl : UISegmentedControl!
    
    var openState : ChangeType? {
        get {
            return ChangeType(rawValue: openOrClosedSegmentControl.selectedSegmentIndex)
        }
    }
    
    weak var inspectionTable : InspectionTableViewController!
    weak var state : CellState!
    
    @IBAction func segmentValueDidChange(sender: UISegmentedControl) {
        state.handler?(openState!, self)
        if openState == .Closed {
            state.selectedSegment = UISegmentedControlNoSegment
            
            let alertController = UIAlertController(title: InspectionPsiValveCell.localizedOpenValveTitle, message: nil, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: InspectionPsiValveCell.localizedOkAction, style: .Default, handler: { (sender) -> Void in
                self.openOrClosedSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
                return
            }))
            
            inspectionTable.presentViewController(alertController, animated: true, completion: nil)
        } else {
            state.selectedSegment = sender.selectedSegmentIndex
        }
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionPsiValveCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    public func getValidationFailureViews() -> [UIView] {
        if state.validate() {
            return []
        } else {
            return [openOrClosedSegmentControl]
        }
    }
    
}
