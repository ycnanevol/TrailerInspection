//
//  PopupCompanyPickerViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-31.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class PopupCompanyPickerViewController : ViewControllerBase {
    
    static let prompts : [Constants.CompanyType: String] = [
        .USCarrier: NSLocalizedString("SelectCarrier", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select Carrier", comment: "Prompt text for company picker popup navigation bar when selecting either US or Mexican carriers"),
        .MexicanCarrier: NSLocalizedString("SelectCarrier", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select Carrier", comment: "Prompt text for company picker popup navigation bar when selecting either US or Mexican carriers"),
        .Transfer: NSLocalizedString("SelectTransfer", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select Transfer Company", comment: "Prompt text for company picker popup navigation bar when selecting transfer"),
        .USBroker: NSLocalizedString("SelectBroker", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select US Broker", comment: "Prompt text for company picker popup navigation bar when selecting US broker"),
        .TireBrand: NSLocalizedString("SelectTireBrand", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select Tire Brand", comment: "Prompt text for company picker popup navigation bar when selecting tire brand"),
        // TODO(rgrimm): Refactor this class so it's not so specific to companies. Seal types aren't companies, but are wedged in for simplicity
        .SealType: NSLocalizedString("SelectSealType", tableName: "CompanyPicker", bundle: .mainBundle(), value: "Select Seal Type", comment: "Prompt text for \"company picker\" popup navigation bar when selecting seal type."),
        .Unknown: "Unknown Company Type!",
    ]
    
    @IBOutlet weak var pickerNavItem: UINavigationItem! {
        didSet {
            pickerNavItem.prompt = PopupCompanyPickerViewController.prompts[companyType]
        }
    }
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.selectRow(_selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    private var values : [String] = []
    
    var companyType : Constants.CompanyType = .Unknown {
        didSet {
            if let values = Constants.companiesByType[companyType] {
                self.values = values.map { (company) -> String in
                    return company.name
                }
            } else {
                values = []
            }
            
            pickerNavItem?.prompt = PopupCompanyPickerViewController.prompts[companyType]
        }
    }
    
    private var _selectedIndex : Int = 0
    var selectedCompany : Company? {
        get {
            if let companyArray = Constants.companiesByType[companyType] {
                _selectedIndex = pickerView.selectedRowInComponent(0)
                return companyArray[_selectedIndex]
            } else {
                return nil
            }
        }
        set {
            
            if let value = newValue,
                let companyArray = Constants.companiesByType[companyType],
                let selectedIndex = find(companyArray, value) {
                    _selectedIndex = selectedIndex
            }
            
            pickerView?.selectRow(_selectedIndex, inComponent: 0, animated: true)
        }
    }
    
    // MARK: Navigation stack
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("SingleItemPicker")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("SingleItemPicker")
    }
    
}


// MARK: - UIPickerViewDataSource extension
extension PopupCompanyPickerViewController : UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
}

// MARK: - UIPickerViewDelegate extension
extension PopupCompanyPickerViewController : UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return values[row]
    }
    
}
