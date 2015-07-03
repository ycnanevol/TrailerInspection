//
//  InspectionMonthYearCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-06.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionMonthYearCell : UITableViewCell {
    
    // MARK: InspectionMonthYearCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, changeHandler : ((changeType : ChangeType, sender : InspectionMonthYearCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            
            self.handler = changeHandler
        }
        
        var labelText : String!
        
        var dateValue : NSDate?
        
        var handler : ((ChangeType, InspectionMonthYearCell) -> Void)?
        
        public override func validate() -> Bool {
            if dateValue == nil {
                return false
            }
            
            return dateValue != nil
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("MonthYearCell", forIndexPath: indexPath) as! InspectionMonthYearCell
            
            cell.inspectionTableController = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText
            
            if let dateValue = dateValue {
                cell.monthYearButton.setTitle(PopupMonthYearPickerViewController.monthYearFormatter.stringFromDate(dateValue), forState: .Normal)
            }
            
            return cell
        }
        
    }
    
    public enum ChangeType {
        case Date(value : NSDate)
    }
    
    // MARK: InspectionMonthYearCell members
    @IBOutlet weak var cellLabel : UILabel!
    @IBOutlet weak var monthYearButton: UIButton!
    
    weak var inspectionTableController : InspectionTableViewController!
    weak var state : CellState!

    @IBAction func performMonthYearSelectSegue() {
        
        inspectionTableController.popoverAnchor = monthYearButton
        inspectionTableController.popoverSegueDelegate = self
        inspectionTableController.performSegueWithIdentifier("MonthYearSegue", sender: self)
        
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionMonthYearCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    public func getValidationFailureViews() -> [UIView] {
        if !state.validate() {
            return [monthYearButton]
        }
        
        return []
    }
    
}

// MARK: - InspectionSegueDelegate extension
extension InspectionMonthYearCell : InspectionSegueDelegate {
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dateValue = state.dateValue,
            let destination = segue.destinationViewController as? PopupMonthYearPickerViewController {
                destination.selectedDate = dateValue
        }
    }
    
    public func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "MonthYearSaveUnwindSegue",
            let source = segue.sourceViewController as? PopupMonthYearPickerViewController {
            
                state.dateValue = source.selectedDate
                monthYearButton.setTitle(PopupMonthYearPickerViewController.monthYearFormatter.stringFromDate(source.selectedDate), forState: .Normal)
                state.handler?(.Date(value: source.selectedDate), self)
                
        }
    }
    
}
