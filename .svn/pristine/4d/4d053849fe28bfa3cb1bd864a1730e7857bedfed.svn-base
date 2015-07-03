//
//  InspectionTireCellAlternate.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-10.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionTireCellAlternate : UITableViewCell {
    
    static let labelFormat = NSLocalizedString("TireCellLabel", tableName: "InspectionTable", bundle: .mainBundle(), value: "Tire #%ld", comment: "Formatted text for the cell label for tire inspection cells")
    
    // MARK: InspectionTireCellAlternate.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(tireNumber : Int, withPsiInput : Bool, depthRange : Range<Int>, psiRange : Range<Int>?, changeHandler : ((changeType : ChangeType, sender : InspectionTireCellAlternate) -> Void)? = nil) {
            self.init()
            
            self.labelText = String(format: labelFormat, tireNumber)
            
            self.withPsi = withPsiInput
            
            self.depthRange = depthRange
            self.psiRange = psiRange
            
            self.handler = changeHandler
        }
        
        var reusableId : String {
            if withPsi {
                return "TireCellAlternateWithPsi"
            } else {
                return "TireCellAlternate"
            }
        }
        
        var labelText : String!
        var withPsi : Bool = false
        var depthRange : Range<Int>!
        var psiRange : Range<Int>!
        
        var brandCompany : Company?
        var brandText : String?
        var tireDepth : String?
        var psiValue : String?
        var selectedCapSegment = UISegmentedControlNoSegment
        
        var handler : ((ChangeType, InspectionTireCellAlternate) -> Void)?
        
        public override func validate() -> Bool {
            if brandCompany == nil {
                return false
            }
            
            if brandCompany == Constants.otherCompany && (brandText == nil || brandText!.isEmpty) {
                return false
            }
            
            if tireDepth?.toInt() == nil || !contains(depthRange, tireDepth!.toInt()!) {
                return false
            }
            
            if withPsi {
                if psiValue?.toInt() == nil || !contains(psiRange, psiValue!.toInt()!) {
                    return false
                }
            }
            
            if selectedCapSegment == UISegmentedControlNoSegment {
                return false
            }
            
            return true
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier(reusableId, forIndexPath: indexPath) as! InspectionTireCellAlternate
            
            cell.inspectionTableController = inspectionTable
            cell.state = self
            
            cell.cellLabel.text = labelText

            if brandCompany != Constants.otherCompany {
                cell.brandTextField.text = brandCompany?.name
            } else {
                cell.brandTextField.text = brandText
            }
            
            cell.tireDepthTextField.text = tireDepth
            cell.psiTextField?.text = psiValue
            
            cell.capTypeSegmentControl.selectedSegmentIndex = selectedCapSegment
            
            return cell
        }
    }
    
    public enum CapType {
        case Original
        case Recap
    }
    
    public enum ChangeType {
        case Brand(brand : Company)
        case OtherBrand(brand : String)
        case Depth(depth : Int)
        case Psi(value : Int)
        case Cap(type : CapType)
    }
    
    // MARK: InspectionTireCellAlternate members
    @IBOutlet weak var cellLabel : UILabel!
    @IBOutlet weak var brandTextField : UITextField! {
        didSet {
            brandTextField.delegate = self
        }
    }
    @IBOutlet weak var tireDepthTextField : UITextField! {
        didSet {
            tireDepthTextField.delegate = self
        }
    }
    @IBOutlet weak var psiTextField : UITextField! {
        didSet {
            psiTextField.delegate = self
        }
    }
    @IBOutlet weak var capTypeSegmentControl : UISegmentedControl!
    
    var otherBrandSelected = false
    
    weak var state : CellState!
    
    weak var inspectionTableController : InspectionTableViewController!
    
    @IBAction func segmentValueDidChange(sender : UISegmentedControl) {
        switch sender {
        case capTypeSegmentControl:
            state.selectedCapSegment = sender.selectedSegmentIndex
            state.handler?(.Cap(type: state.selectedCapSegment == 0 ? .Original : .Recap), self)
        default:
            WernerLog("Unknown control called InspectionTireCellAlternate::segmentValueDidChange()")
        }
    }
}

// MARK: - UITextFieldDelegate extension
extension InspectionTireCellAlternate : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if textField == brandTextField && !otherBrandSelected {
            textField.resignFirstResponder()
            inspectionTableController.popoverAnchor = brandTextField
            inspectionTableController.popoverSegueDelegate = self
            inspectionTableController.performSegueWithIdentifier("SelectCompanySegue", sender: self)
        }
        
        otherBrandSelected = false
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case brandTextField:
            state.brandText = textField.text
            if state.brandCompany == Constants.otherCompany && textField.text != "" {
                state.handler?(.OtherBrand(brand: textField.text), self)
            }
        case tireDepthTextField:
            state.tireDepth = textField.text
            if let depth = textField.text.toInt() where contains(state.depthRange, depth) {
                state.handler?(.Depth(depth: depth), self)
            }
        case psiTextField:
            state.psiValue = textField.text
            if let psiValue = textField.text.toInt() where contains(state.psiRange, psiValue) {
                state.handler?(.Psi(value: psiValue), self)
            }
        default:
            WernerLog("Unknown control called InspectionTireCellAlternate::textFieldDidEndEditing()")
        }
        
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case brandTextField:
            tireDepthTextField.becomeFirstResponder()
        case tireDepthTextField:
            if state.withPsi {
                psiTextField.becomeFirstResponder()
            } else {
                tireDepthTextField.resignFirstResponder()
            }
        case psiTextField:
            psiTextField.resignFirstResponder()
        default:
            return false
        }
        
        return true
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionTireCellAlternate : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        if brandTextField != nil && brandTextField.text.isEmpty {
            failedViews.append(brandTextField)
        }
        
        if tireDepthTextField.text?.toInt() == nil || !contains(state.depthRange, tireDepthTextField.text.toInt()!) {
            failedViews.append(tireDepthTextField)
        }
        
        if state.withPsi && (psiTextField.text?.toInt() == nil || !contains(state.psiRange, psiTextField.text.toInt()!)) {
            failedViews.append(psiTextField)
        }
        
        if capTypeSegmentControl?.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(capTypeSegmentControl)
        }
        
        return failedViews
    }
    
}

// MARK: - InspectionSegueDelegate extension
extension InspectionTireCellAlternate : InspectionSegueDelegate {
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender : AnyObject?) {
        if let destination = segue.destinationViewController as? PopupCompanyPickerViewController {
            destination.companyType = .TireBrand
            destination.selectedCompany = state.brandCompany
        }
    }
    
    public func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "CompanySaveUnwindSegue",
            let companySource = segue.sourceViewController as? PopupCompanyPickerViewController {
                if let selectedCompany = companySource.selectedCompany {
                    if selectedCompany == Constants.otherCompany {
                        // Clear the text field text if the option changed to "Other"
                        if selectedCompany != state.brandCompany {
                            brandTextField.text = ""
                        }
                        otherBrandSelected = true
                        brandTextField.becomeFirstResponder()
                    } else {
                        brandTextField.text = selectedCompany.name
                        brandTextField.resignFirstResponder()
                    }
                    state.brandCompany = selectedCompany
                    state.handler?(.Brand(brand: selectedCompany), self)
                } else {
                    state.brandCompany = nil
                    brandTextField.text = ""
                }

                state.brandText = brandTextField.text
        }
    }
    
}
