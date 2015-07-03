//
//  DamageDetailCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-07.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class DamageDetailCell : UITableViewCell {
    
    static var labelTexts : [InspectionDamageType: String] = [
        .Bruise: NSLocalizedString("Bruise", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Bruise", comment: "Text for bruise"),
        .Cut: NSLocalizedString("Cut", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Cut", comment: "Text for cut"),
        .Dent: NSLocalizedString("Dent", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Dent", comment: "Text for dent"),
        .Hole: NSLocalizedString("Hole", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Hole", comment: "Text for hole"),
        .Missing: NSLocalizedString("Missing", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Missing", comment: "Text for missing"),
        .Patches: NSLocalizedString("Patches", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Patches", comment: "Text for patches"),
        .Scratches: NSLocalizedString("Scratches", tableName: "DamageTypeList", bundle: .mainBundle(), value: "Scratches", comment: "Text for scratches"),
    ]
    
    private static var _supportedDamageTypes : [InspectionDamageType] = {
        return DamageDetailCell.labelTexts.keys.array.sorted { (left, right) -> Bool in
            return DamageDetailCell.labelTexts[left]! < DamageDetailCell.labelTexts[right]!
        }
    }()
    
    public static var supportedDamageTypes : [InspectionDamageType] {
        return _supportedDamageTypes
    }
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var damageToggle : UISwitch!
    
    var tapRecognizer : UITapGestureRecognizer!
    
    var originalTextColor : UIColor!
    var originalBackgroundColor : UIColor?
    
    private var _damageType : InspectionDamageType!
    public var damageType : InspectionDamageType {
        get {
            return _damageType!
        }
    }
    public var delegate : DamageDetailCellDelegate?
    
    public class func cellForTableView(tableView: UITableView, damageType : InspectionDamageType, initialState : Bool, delegate : DamageDetailCellDelegate?) -> DamageDetailCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DamageDetailCell") as! DamageDetailCell
        
        cell.cellLabel.text = labelTexts[damageType]
        cell.damageToggle.on = initialState
        cell._damageType = damageType
        cell.delegate = delegate
        
        // Use tapRecognizer to know whether the cell has been initialized previously
        if cell.tapRecognizer == nil {
            // Add tapRecognizeer
            cell.tapRecognizer = UITapGestureRecognizer(target: cell, action: "performToggle")
            cell.tapRecognizer.numberOfTapsRequired = 1
            cell.tapRecognizer.numberOfTouchesRequired = 1
            cell.addGestureRecognizer(cell.tapRecognizer)
            
            // Pull the default colors from the switch
            cell.originalTextColor = cell.cellLabel.textColor
            cell.originalBackgroundColor = cell.backgroundColor
        }
        
        return cell
    }
    
    func performToggle() {
        damageToggle.setOn(!damageToggle.on, animated: true)
        toggleState(damageToggle)
    }
    
    @IBAction func toggleState(sender: UISwitch) {
        switch damageType {
        case let .Other(additional):
            delegate?.damageValueDidChange(damageTypeHash: damageType.hashValue, additional: additional, value: sender.on)
        default:
            delegate?.damageValueDidChange(damageTypeHash: damageType.hashValue, additional: nil, value: sender.on)
        }
    }
    
    public func setValidationFailHighlight(highlightEnabled : Bool) {
        if highlightEnabled {
            cellLabel.textColor = Constants.validationFailTextColor
            backgroundColor = Constants.validationFailHighlightColor
        } else {
            cellLabel.textColor = originalTextColor
            backgroundColor = originalBackgroundColor
        }
    }
    
}

// MARK: - DamageDetailCellDelegate protocol
@objc public protocol DamageDetailCellDelegate {
    
    func damageValueDidChange(#damageTypeHash : Int, additional : String?, value : Bool)
    
}
