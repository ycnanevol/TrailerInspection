//
//  PopupMonthYearPickerViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-21.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class PopupMonthYearPickerViewController : ViewControllerBase {
    
    static let calendar : NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    
    static let monthFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        
        formatter.calendar = PopupMonthYearPickerViewController.calendar
        formatter.dateFormat = "MMMM"
        
        return formatter
    }()
    
    static let yearFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        
        formatter.calendar = PopupMonthYearPickerViewController.calendar
        formatter.dateFormat = "yyyy"
        
        return formatter
    }()
    
    static let monthYearFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        
        formatter.calendar = PopupMonthYearPickerViewController.calendar
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter
    }()
    
    var yearRange : Range<Int> = -1...1
    
    lazy var yearOptions : [NSDateComponents] = {
        var options : [NSDateComponents] = []
        
        let thisYear = PopupMonthYearPickerViewController.calendar.components(.CalendarUnitYear, fromDate: NSDate()).year
        
        return self.yearRange.map { (yearDelta) -> NSDateComponents in
            let option = NSDateComponents()
            
            option.year = thisYear + yearDelta
            
            return option
        }
    }()
    
    lazy var selectedYearRow : Int = {
        let thisYear = PopupMonthYearPickerViewController.calendar.components(.CalendarUnitYear, fromDate: NSDate())
        
        return find(self.yearOptions, thisYear)!
    }()
    
    lazy var selectedMonthRow : Int = {
        let thisMonth = PopupMonthYearPickerViewController.calendar.components(.CalendarUnitMonth, fromDate: NSDate()).month
        
        return thisMonth - 1
    }()
    
    var selectedDate : NSDate {
        get {
            let components = NSDateComponents()
            
            components.month = selectedMonthRow + 1
            components.year = yearOptions[selectedYearRow].year
            
            return PopupMonthYearPickerViewController.calendar.dateFromComponents(components)!
        }
        set {
            let components = PopupMonthYearPickerViewController.calendar.components(.CalendarUnitMonth | .CalendarUnitYear, fromDate: newValue)
            
            selectedMonthRow = components.month - 1
            
            for index in indices(yearOptions) {
                if yearOptions[index] == components.year {
                    selectedYearRow = index
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var monthYearPicker : UIPickerView!
    
    // MARK: Navigation stack
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("MonthYearPicker")
        
        monthYearPicker.selectRow(selectedMonthRow, inComponent: 0, animated: false)
        monthYearPicker.selectRow(selectedYearRow, inComponent: 1, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("MonthYearPicker")
    }
    
}

// MARK: - UIPickerViewDataSource extension
extension PopupMonthYearPickerViewController : UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 12
        default: return yearOptions.count
        }
    }
    
}

// MARK: - UIPickerViewDelegate extension
extension PopupMonthYearPickerViewController : UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            let monthComponent = NSDateComponents()
            monthComponent.month = row + 1
            
            return PopupMonthYearPickerViewController.monthFormatter.stringFromDate(PopupMonthYearPickerViewController.calendar.dateFromComponents(monthComponent)!)
        default:
            if !contains(indices(yearOptions), row) {
                return nil
            }
            
            return PopupMonthYearPickerViewController.yearFormatter.stringFromDate(PopupMonthYearPickerViewController.calendar.dateFromComponents(yearOptions[row])!)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: selectedMonthRow = row
        default: selectedYearRow = row
        }
    }
    
}
