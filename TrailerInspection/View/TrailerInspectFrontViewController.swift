//
//  TrailerInspectFrontViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 4/8/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class TrailerInspectFrontViewController : InspectionViewControllerBase {
    
    // Placing these here to avoid a compiler SegFault
    typealias InspectionSection = InspectionTableViewController.CellStateSection
    typealias TcuCell = InspectionTcuCell.CellState
    typealias TriStateCell = InspectionTriStateDamageCell.CellState
    typealias MonthYearCell = InspectionMonthYearCell.CellState
    typealias DualStateCell = InspectionDualStateDamageCell.CellState
    typealias MultiLightCell = InspectionMultiLightDamageCell.CellState
    typealias SingleLightCell = InspectionSingleLightDamageCell.CellState
    typealias TireCell = InspectionTireCellAlternate.CellState
    typealias PsiValveCell = InspectionPsiValveCell.CellState
    typealias SealCell = InspectionSealInfoCell.CellState
    typealias OtherCell = InspectionOtherDamageCell.CellState
    typealias LiquidLevelCell = InspectionLiquidLevelCell.CellState
    
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("InspectFront")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("InspectFront")
    }
    
}

extension TrailerInspectFrontViewController : InspectionFormDataSource {
    
    func getInspectionItems() -> [InspectionTableViewController.CellStateBase] {
        var inspectionItems : [InspectionTableViewController.CellStateBase] = []
        
        // MARK: - Main inspection
        // TODO(rgrimm): Localize the labels
        inspectionItems.append(InspectionSection(label: "Inspection"))
        
        inspectionItems.append(DualStateCell(label: "Placard Holder", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontPlacardHolder = changeType
        }))
        inspectionItems.append(DualStateCell(label: "VIN Plate", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontVinPlate = changeType
        }))
        inspectionItems.append(DualStateCell(label: "Gladhands", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontGladHands = changeType
        }))
        inspectionItems.append(DualStateCell(label: "Bill Box", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontBillBox = changeType
        }))
        inspectionItems.append(DualStateCell(label: "Permit Box", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontPermitBox = changeType
        }))
        
        if trailer.trailerType == .TCU {
            inspectionItems.append(InspectionSection(label: "TCU"))
            
            inspectionItems.append(DualStateCell(label: "Upper Doors", changeHandler: { (changeType, sender) -> Void in
                self.inspection.tcuInfo.upperDoors = changeType
            }))
            
            inspectionItems.append(DualStateCell(label: "Lower Doors", changeHandler: { (changeType, sender) -> Void in
                self.inspection.tcuInfo.lowerDoors = changeType
            }))
            
            inspectionItems.append(DualStateCell(label: "Grill", changeHandler: { (changeType, sender) -> Void in
                self.inspection.tcuInfo.grill = changeType
            }))
            
            inspectionItems.append(DualStateCell(label: "Belts", changeHandler: { (changeType, sender) -> Void in
                self.inspection.tcuInfo.belts = changeType
            }))
            
            
            inspectionItems.append(DualStateCell(label: "Hoses", changeHandler: { (changeType, sender) -> Void in
                self.inspection.tcuInfo.hoses = changeType
            }))
            
            inspectionItems.append(LiquidLevelCell(label: "Anti-Freeze", changeHandler: { (changeType, sender) -> Void in
                switch changeType {
                case .OK: self.inspection.tcuInfo.isAntiFreezeLow = .False
                case .Low: self.inspection.tcuInfo.isAntiFreezeLow = .True
                }
            }))
            
            inspectionItems.append(LiquidLevelCell(label: "Oil", changeHandler: { (changeType, sender) -> Void in
                switch changeType {
                case .OK: self.inspection.tcuInfo.isOilLow = .False
                case .Low: self.inspection.tcuInfo.isOilLow = .True
                }
            }))
        }

        // MARK: - Other
        inspectionItems.append(InspectionSection(label: "Additional Damage"))
        inspectionItems.append(OtherCell(label: "Additional Damage", changeHandler: { (changeType, sender) -> Void in
            self.inspection.frontOther = changeType
        }))
        
        return inspectionItems
    }
    
}
