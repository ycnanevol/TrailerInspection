//
//  TrailerInfoViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class TrailerInfoViewController : InspectionViewControllerBase {
    
    @IBOutlet weak var trailerInfoTableView : UITableView!
    @IBOutlet weak var emptyOrLoadedSegmentControl : UISegmentedControl!
    @IBOutlet weak var tireTypeSegmentControl : UISegmentedControl!
    @IBOutlet weak var carrierCountrySegmentControl : UISegmentedControl!
    @IBOutlet weak var carrierSelectButton : UIButton!
    @IBOutlet weak var truckNumberTextField: UITextField!
    @IBOutlet weak var tripNumberTextField: UITextField!
    @IBOutlet weak var transferAndBrokerButton: UIButton!
    
    @IBOutlet weak var carrierCountryPartialConstraint : NSLayoutConstraint!
    @IBOutlet weak var carrierCountryFullConstraint : NSLayoutConstraint!
    @IBOutlet weak var carrierCountryToButtonSpacingConstraint: NSLayoutConstraint!
    
    var carrierCountrySegmentLastSelected = UISegmentedControlNoSegment
    
    var carrierButtonOriginalTitle : String!
    let transferButtonOriginalTitle : String = NSLocalizedString("TransferButtonText", tableName: "CheckInScreen", bundle: .mainBundle(), value: "Transfer Company", comment: "Text to display when the user should have the option of selecting a transfer company")
    var usBrokerButtonOriginalTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carrierButtonOriginalTitle = carrierSelectButton.currentTitle
        usBrokerButtonOriginalTitle = transferAndBrokerButton.currentTitle

        // Set visibility on/off to make sure it's in the right state at the start
        setCarrierSelectorVisibility(true, animated: false)
        setCarrierSelectorVisibility(false, animated: false)
        
        switch inspection.trailer.isLoaded {
        case .True:
            inspection.isLoaded = true
            emptyOrLoadedSegmentControl.selectedSegmentIndex = 0
        case .Unknown:
            emptyOrLoadedSegmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
        case .False:
            emptyOrLoadedSegmentControl.selectedSegmentIndex = 1
            inspection.isLoaded = false
        }

    }
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("TrailerInfo")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("TrailerInfo")
    }
    
    func setCarrierSelectorVisibility(visible : Bool, animated : Bool = true) {
        // Since the order matters, activate/deactivate constraints in specific order
        var updateConstraints : () -> Void
        if visible {
            updateConstraints = {  () -> Void in
                self.carrierCountryFullConstraint.active = false
                self.carrierCountryPartialConstraint.active = true
                self.carrierCountryToButtonSpacingConstraint.active = true
                self.view.layoutIfNeeded()
            }
        } else {
            updateConstraints = { () -> Void in
                self.carrierCountryToButtonSpacingConstraint.active = false
                self.carrierCountryPartialConstraint.active = false
                self.carrierCountryFullConstraint.active = true
                self.view.layoutIfNeeded()
            }
        }
        
        self.carrierSelectButton.hidden = !visible
        
        if animated {
            UIView.animateWithDuration(Constants.animationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .BeginFromCurrentState, animations: updateConstraints) { (finished) -> Void in
            }
        } else {
            updateConstraints()
        }
    }
    
    func setButtonVisibility(button : UIButton, visible : Bool, animated : Bool) {
        if button.hidden == !visible {
            return
        }
        
        button.enabled = visible
        
        if animated {
            UIView.animateWithDuration(Constants.animationDuration) { () -> Void in
                button.hidden = !visible
            }
        } else {
            button.hidden = !visible
        }
    }
    
    @IBAction func carrierCountryChanged(sender: AnyObject) {
        carrierSelectButton.setTitle(carrierButtonOriginalTitle, forState: .Normal)
        
        if carrierCountrySegmentControl.selectedSegmentIndex == 2 {
            // Werner
            inspection.carrier = Constants.wernerCompany
            setCarrierSelectorVisibility(false)
        } else {
            // Mexican or US
            inspection.carrier = nil
            setCarrierSelectorVisibility(true)
        }
        
        if carrierCountrySegmentControl.selectedSegmentIndex == 0 {
            // Mexican
            transferAndBrokerButton.setTitle(transferButtonOriginalTitle, forState: .Normal)
            inspection.usBroker = nil
            setButtonVisibility(transferAndBrokerButton, visible: false, animated: true)
        } else {
            // US or Werner
            if !contains(1...2, carrierCountrySegmentLastSelected) {
                transferAndBrokerButton.setTitle(usBrokerButtonOriginalTitle, forState: .Normal)
                inspection.transfer = nil
            }
        }
        
        carrierCountrySegmentLastSelected = carrierCountrySegmentControl.selectedSegmentIndex
        setButtonVisibility(transferAndBrokerButton, visible: true, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let popupPicker = segue.destinationViewController as? PopupCompanyPickerViewController {
            if segue.identifier == "SelectCarrierSegue" {
                switch carrierCountrySegmentControl.selectedSegmentIndex {
                case 0:
                    popupPicker.companyType = .MexicanCarrier
                case 1:
                    popupPicker.companyType = .USCarrier
                default:
                    popupPicker.companyType = .Unknown
                }
                if inspection.carrier != nil {
                    popupPicker.selectedCompany = inspection.carrier
                }
            } else {
                switch carrierCountrySegmentControl.selectedSegmentIndex {
                case 0:
                    // Mexican
                    popupPicker.companyType = .Transfer
                    popupPicker.selectedCompany = inspection.transfer
                case 1:
                    // US
                    fallthrough
                case 2:
                    // Werner
                    popupPicker.companyType = .USBroker
                    popupPicker.selectedCompany = inspection.usBroker
                default:
                    popupPicker.companyType = .Unknown
                }
            }
        }
    }

    @IBAction func prepareForUnwindSegue(segue : UIStoryboardSegue) {
        if let source = segue.sourceViewController as? PopupCompanyPickerViewController {
            if !source.isBeingDismissed() {
                source.dismissViewControllerAnimated(true, completion: nil)
            }
            
            if segue.identifier == "CompanySaveUnwindSegue",
                let selectedCompany = source.selectedCompany {
                    var button : UIButton
                    switch source.companyType {
                    case .MexicanCarrier:
                        fallthrough
                    case .USCarrier:
                        inspection.carrier = selectedCompany
                        button = carrierSelectButton
                    case .Transfer:
                        inspection.transfer = selectedCompany
                        button = transferAndBrokerButton
                    case .USBroker:
                        inspection.usBroker = selectedCompany
                        button = transferAndBrokerButton
                    default:
                        WernerLog("Unknown unwind segue; not persisting data!")
                        return
                    }
                    
                    button.setTitle(selectedCompany.name, forState: button.state)
            }
        }
    }
}

extension TrailerInfoViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var hasAeroSkirt = false
            
            return TrailerNumberAndIndicatorCell.cellForTableView(trailerInfoTableView, trailerNumber: trailer.trailerNumber, hasAeroSkirt: trailer.isAeroSkirtEquipped.boolValue, hasPsi: trailer.isPsiEquipped.boolValue, hasGps: trailer.isGpsEquipped.boolValue)
        } else {
            var labels : [String]
            var values : [String]
            
            // TODO(rgrimm): Internationalize the labels
            switch indexPath.item {
            case 0:
                labels = [ "License", "State" ]
                values = [ "\(trailer.licenseNumber)", "\(trailer.licenseState)" ]
            case 1:
                labels = [ "Year" ]
                values = [ "\(trailer.modelYear)" ]
            case 2:
                labels = [ "Make" ]
                values = [ "\(trailer.make)" ]
            case 3:
                labels = [ "Type" ]
                values = [ "\(trailer.trailerType)" ]
            case 4:
                labels = [ "VIN" ]
                values = [ "\(trailer.vin)" ]
            default:
                labels = []
                values = []
            }
            
            return TrailerTwoColumnCell.cellForTableView(tableView, columnLabels: labels, columnValues: values)
            
        }
    }
}

extension TrailerInfoViewController : InspectionFormValidationDelegate {
    
    func getValidationPassingState() -> Bool {
        return getValidationFailureViews().isEmpty
    }
    
    // Most of the forms will auto-save; this one is kind of a hack, so it saves in its validation function
    func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        switch emptyOrLoadedSegmentControl.selectedSegmentIndex {
        case UISegmentedControlNoSegment:
            failedViews.append(emptyOrLoadedSegmentControl)
        case 0:
            inspection.isLoaded = false
        default:
            inspection.isLoaded = true
        }
        
        if carrierCountrySegmentControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            failedViews.append(carrierCountrySegmentControl)
        } else if inspection.carrier == nil {
            failedViews.append(carrierSelectButton)
        }
        
        if tireTypeSegmentControl.selectedSegmentIndex != 0 {
            inspection.tireType = .WideBase
        }
        
        if truckNumberTextField.text.isEmpty {
            failedViews.append(truckNumberTextField)
        } else {
            inspection.truckNumber = truckNumberTextField.text
        }
        
        if !tripNumberTextField.text.isEmpty {
            inspection.tripNumber = tripNumberTextField.text
        }
        
        return failedViews
    }

}

extension TrailerInfoViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case truckNumberTextField:
            tripNumberTextField.becomeFirstResponder()
        case tripNumberTextField:
            tripNumberTextField.resignFirstResponder()
        default:
            return false
        }
        
        return true
    }
    
}

