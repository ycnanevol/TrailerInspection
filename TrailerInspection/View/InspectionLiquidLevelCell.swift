//
//  InspectionLiquidLevelCell.swift
//  TrailerInspection
//
//  Created by Gary Chen on 2015-06-01.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionLiquidLevelCell : UITableViewCell {
    
    // MARK: InspectionPsiValveCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, changeHandler : ((changeType : ChangeType, sender : InspectionLiquidLevelCell) -> Void)? = nil) {
            self.init()
            
            self.labelText = label
            
            self.handler = changeHandler
        }
        
        var labelText : String!
        
        var selectedSegment = UISegmentedControlNoSegment
        
        var handler : ((ChangeType, InspectionLiquidLevelCell) -> Void)?
        
        public override func validate() -> Bool {
            return selectedSegment != UISegmentedControlNoSegment
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("LiquidLevelCell", forIndexPath: indexPath) as! InspectionLiquidLevelCell
            
            cell.inspectionTable = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText
            
            return cell
        }
        
    }
    
    public enum ChangeType : Int {
        case OK = 0
        case Low
    }
    
    // MARK: InspectionPsiValveCell members
    @IBOutlet weak var cellLabel : UILabel!
    @IBOutlet weak var liquidLevelSegmentControl : UISegmentedControl!
    
    var liquidLevel : ChangeType? {
        get {
            return ChangeType(rawValue: liquidLevelSegmentControl.selectedSegmentIndex)
        }
    }
    
    weak var inspectionTable : InspectionTableViewController!
    weak var state : CellState!
    
    @IBAction func segmentValueDidChange(sender: UISegmentedControl) {
        state.selectedSegment = sender.selectedSegmentIndex
        state.handler?(liquidLevel!, self)
    }
}



