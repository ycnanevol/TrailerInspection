//
//  TrailerInspectRightViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 4/8/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class TrailerInspectRightViewController : InspectionViewControllerBase {
    
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

    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("InspectRight")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("InspectRight")
    }
    
}

extension TrailerInspectRightViewController : InspectionFormDataSource {

    func getInspectionItems() -> [InspectionTableViewController.CellStateBase] {
        var inspectionItems : [InspectionTableViewController.CellStateBase] = []
        
        // MARK: - Tire inspection
        // TODO(rgrimm): Localize the labels
        inspectionItems.append(InspectionSection(label: "Tire Inspection"))
        
        inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 3)
        if inspection.tireType == .Dual {
            inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 4)
        }
        inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 7)
        if inspection.tireType == .Dual {
            inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 8)
        }
        
        // MARK: - Main inspection
        inspectionItems.append(InspectionSection(label: "Inspection"))
        
        inspectionItems.append(DualStateCell(label: "Placard Holder", changeHandler: { (changeType, sender) -> Void in
            self.inspection.rightPlacardHolder = changeType
        }))
        
        inspectionItems.append(TriStateCell(label: "Arrow Turning Lights", changeHandler: { (changeType, sender) -> Void in
            self.inspection.rightArrowTurningLights = changeType
        }))
        
        if trailer.isAeroSkirtEquipped == .True || (trailer.isAeroSkirtEquipped == .Unknown && inspection.leftAeroSkirt != .NA) {
            inspectionItems.append(DualStateCell(label: "Aero Skirt", changeHandler: { (changeType, sender) -> Void in
                self.inspection.rightAeroSkirt = changeType
            }))
        }
        
        inspectionItems.append(MultiLightCell(label: "Yellow Marker Lights", changeHandler: TrailerInspectLeftViewController.buildMultiLightHandler(target: &inspection.rightYellowMarkerLights)))
        inspectionItems.append(SingleLightCell(label: "Red Marker Light", changeHandler: TrailerInspectLeftViewController.buildSingleLightHandler(target: &inspection.rightRedMarkerLights)))
        
        // MARK: - Roof inspection
        if inspection.roof == nil || inspection.roof == .NA {
            inspectionItems.append(InspectionSection(label: "Roof Inspection"))
            
            inspectionItems.append(DualStateCell(label : "Roof", changeHandler: { (changeType, sender) -> Void in
                self.inspection.roof = changeType
            }))
        }
        
        // MARK: - Other
        inspectionItems.append(InspectionSection(label: "Additional Damage"))
        inspectionItems.append(OtherCell(label: "Additional Damage", changeHandler: { (changeType, sender) -> Void in
            self.inspection.rightOther = changeType
        }))
        
        return inspectionItems
    }
    
}
