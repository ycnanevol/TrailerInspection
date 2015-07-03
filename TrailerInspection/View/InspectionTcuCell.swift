//
//  InspectionTcuCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-03.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionTcuCell : UITableViewCell {

    // MARK: InspectionTcuCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String, isLoaded : Bool, temperatureRange : Range<Int>, setRange : Range<Int>, changeHandler : ((changeType : ChangeType, sender : InspectionTcuCell) -> Void)? = nil) {
            
            self.init()
            
            self.labelText = label
            self.isLoaded = isLoaded
            self.temperatureRange = temperatureRange
            self.setRange = setRange
            
            self.handler = changeHandler
        }
        
        var reusableId : String {
            if isLoaded {
                return "TcuEntryCellLoaded"
            } else {
                return "TcuEntryCellEmpty"
            }
        }
        
        var labelText : String!
        var isLoaded : Bool = true
        var temperatureRange : Range<Int>!
        var setRange : Range<Int>!
        
        var temperatureValue : String?
        var setValue : String?
        var fuelLevel : Int = UISegmentedControlNoSegment
        
        var handler : ((ChangeType, InspectionTcuCell) -> Void)?
        
        public override func validate() -> Bool {
            if fuelLevel == UISegmentedControlNoSegment {
                return false
            }
            
            if isLoaded,
                let temperatureInt = temperatureValue?.toInt(), let setInt = setValue?.toInt() {
                    if !contains(temperatureRange, temperatureInt) {
                        return false
                    }
                    
                    if !contains(setRange, setInt) {
                        return false
                    }
            }
            
            return true
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable : InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier(reusableId, forIndexPath: indexPath) as! InspectionTcuCell
            
            cell.state = self
            cell.cellLabel.text = labelText

            if isLoaded {
                cell.temperatureTextField.text = temperatureValue
                cell.setTextField.text = setValue
            }
            cell.fuelLevelSegmentControl.selectedSegmentIndex = fuelLevel
            
            return cell
        }
        
    }

    public enum FuelLevel : Int {
        case Empty = 0, OneQuarter, Half, ThreeQuarter, Full
    }
    
    public enum ChangeType {
        case Temperature(value : Int)
        case Set(value : Int)
        case FuelLevel(value : InspectionTcuCell.FuelLevel)
    }
    
    // MARK: InspectionTcuCell members
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var temperatureTextField: UITextField! {
        didSet {
            temperatureTextField.delegate = self
        }
    }
    @IBOutlet weak var setTextField: UITextField! {
        didSet {
            setTextField.delegate = self
        }
    }
    @IBOutlet weak var fuelLevelSegmentControl: UISegmentedControl!

    weak var state : CellState!
    
    @IBAction func segmentValueDidChange(sender: UISegmentedControl) {
        state.fuelLevel = sender.selectedSegmentIndex
        if let fuelLevel = FuelLevel(rawValue: sender.selectedSegmentIndex) {
            state.handler?(.FuelLevel(value: fuelLevel), self)
        }
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionTcuCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    func validateTemperatureValues(textField : UITextField?, range : Range<Int>) -> [UIView] {
        if let intValue = textField?.text.toInt() where contains(range, intValue) {
            return []
        }
        
        return (textField == nil) ? [] : [textField!]
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        if state.isLoaded {
            failedViews += validateTemperatureValues(temperatureTextField, range: state.temperatureRange)
            failedViews += validateTemperatureValues(setTextField, range: state.setRange)
        }
        
        if fuelLevelSegmentControl?.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(fuelLevelSegmentControl)
        }
        
        return failedViews
    }
    
}

// MARK: - UITextFieldDelegate extension
extension InspectionTcuCell : UITextFieldDelegate {
    
    public func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case temperatureTextField:
            state.temperatureValue = textField.text
            if let temperatureInt = textField.text.toInt() where contains(state.temperatureRange, temperatureInt) {
                state.handler?(.Temperature(value: temperatureInt), self)
            }
        case setTextField:
            state.setValue = textField.text
            if let setInt = textField.text.toInt() where contains(state.setRange, setInt) {
                state.handler?(.Set(value: setInt), self)
            }
        default:
            WernerLog("Unknown text field called textFieldDidEndEditing")
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case temperatureTextField:
            setTextField.becomeFirstResponder()
        case setTextField:
            setTextField.resignFirstResponder()
        default:
            return false
        }
        
        return true
    }
    
}
