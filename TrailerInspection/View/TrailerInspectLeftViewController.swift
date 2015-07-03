//
//  TrailerInspectLeftViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-02.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

class TrailerInspectLeftViewController : InspectionViewControllerBase {
    
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
        
        appDelegate.analyticsManager.screenDidAppear("InspectLeft")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("InspectLeft")
    }
    
    // TODO(rgrimm): Find a better home for these helper functions
    class func buildSingleLightHandler(inout #target : Inspection.LightData) -> (changeType : InspectionSingleLightDamageCell.ChangeType, sender : InspectionSingleLightDamageCell) -> Void {
        
        return { (changeType, sender) -> Void in
            switch changeType {
            case let .LightType(lightType):
                if let lightType = lightType {
                    switch lightType {
                    case .LED: target.type = .LED
                    case .Filament: target.type = .Filament
                    }
                } else {
                    target.type = nil
                }
            case let .Damage(damageData):
                switch damageData {
                case .NA: target.numLights = 0
                default: target.numLights = 1
                }
                target.damageData = damageData
            }
        }
    }
    
    class func buildMultiLightHandler(inout #target : Inspection.LightData) -> (changeType : InspectionMultiLightDamageCell.ChangeType, sender : InspectionMultiLightDamageCell) -> Void {
        
        return { (changeType, sender) -> Void in
            switch changeType {
            case let .LightType(lightType):
                switch lightType {
                case .LED: target.type = .LED
                case .Filament: target.type = .Filament
                }
            case let .NumLights(value): target.numLights = value
            case let .Damage(value): target.damageData = value
            }
        }
    }
    
    class func buildTireCells(inout #inspection : Inspection, tireNumber : Int) -> [InspectionTableViewController.CellStateBase] {
        
        var psiRangeValue : Range<Int>?
        
        if !inspection.trailer.isPsiEquipped {
            switch inspection.tireType {
            case .Dual: psiRangeValue = 0...100
            case .WideBase: psiRangeValue = 0...115
            }
        }
        
        // TODO(rgrimm): Localize the string format
        let format = "Wheel #%@"
        
        var cells : [InspectionTableViewController.CellStateBase] = [
            TireCell(tireNumber: tireNumber, withPsiInput: !inspection.trailer.isPsiEquipped, depthRange: 0...26, psiRange: psiRangeValue) { (changeType, sender) -> Void in
                switch changeType {
                case let .Brand(company):
                    inspection.tires[tireNumber - 1].brand = company
                    if company != Constants.otherCompany {
                        inspection.tires[tireNumber - 1].otherBrand = nil
                    }
                case let .OtherBrand(otherBrand):
                    if inspection.tires[tireNumber - 1].brand == Constants.otherCompany {
                        inspection.tires[tireNumber - 1].otherBrand = otherBrand
                    }
                case let .Depth(depth): inspection.tires[tireNumber - 1].depth = depth
                case let .Psi(value): inspection.tires[tireNumber - 1].psiValue = value
                case let .Cap(capType):
                    switch capType {
                    case .Original: inspection.tires[tireNumber - 1].isRecap = false
                    case .Recap: inspection.tires[tireNumber - 1].isRecap = true
                    }
                }
            },
            DualStateCell(label: String(format: format, "\(tireNumber)"), changeHandler: { (changeType, sender) -> Void in
                inspection.tires[tireNumber - 1].damageData = changeType
            })
        ]
        
        let hasHoses : Bool
        
        switch inspection.tireType {
        case .WideBase:
            hasHoses = inspection.trailer.isPsiEquipped.boolValue
        case .Dual:
            hasHoses = (tireNumber % 4) < 2
        }
        
        if hasHoses {
            // TODO(rgrimm): Localize the string format
            let format = "Wheel #%@ PSI Hose"
            cells.append(DualStateCell(label: String(format: format, "\(tireNumber)"), changeHandler: { (changeType, sender) -> Void in
                inspection.tires[tireNumber - 1].psiHose = changeType
            }))
        }
        
        return cells
    }
    
}

extension TrailerInspectLeftViewController : InspectionFormDataSource {
    
    func getInspectionItems() -> [InspectionTableViewController.CellStateBase] {
        var inspectionItems : [InspectionTableViewController.CellStateBase] = []
        
        // MARK: - Main inspection
        // TODO(rgrimm): Localize the labels
        inspectionItems.append(InspectionSection(label: "Inspection"))
        
        if trailer.trailerType == .TCU {
            inspectionItems.append(TcuCell(label: "TCU", isLoaded: inspection.isLoaded, temperatureRange: -30...99, setRange: -20...90, changeHandler: { (changeType, sender) -> Void in
                
                switch changeType {
                case let .Temperature(temperatureValue): self.inspection.tcuInfo.currentTemperatureFahrenheit = temperatureValue
                case let .Set(setValue): self.inspection.tcuInfo.setTemperatureFahrenheit = setValue
                case let .FuelLevel(fuelLevel): self.inspection.tcuInfo.fuelLevel = Float(fuelLevel.rawValue) / 4.0
                }

            }))
        }
        
        let psiLightLabel = "PSI Light"
        if trailer.isPsiEquipped == .True {
            inspectionItems.append(DualStateCell(label: psiLightLabel, changeHandler: { (changeType, sender) -> Void in
                self.inspection.psiLight = changeType
            }))
        } else if trailer.isPsiEquipped == .Unknown {
            inspectionItems.append(TriStateCell(label: psiLightLabel, changeHandler: { (changeType, sender) -> Void in
                self.inspection.psiLight = changeType
            }))
        }
        
        inspectionItems.append(MonthYearCell(label: "DOT Inspection Expiration", changeHandler: { (changeType, sender) -> Void in
            switch changeType {
            case let .Date(value): self.inspection.dotInspectionExpiration = value
            }
        }))
        inspectionItems.append(DualStateCell(label: "Dolly Handle", changeHandler: { (changeType, sender) -> Void in
            self.inspection.leftDollyHandle = changeType
        }))
        inspectionItems.append(DualStateCell(label: "Placard Holder", changeHandler: { (changeType, sender) -> Void in
            self.inspection.leftPlacardHolder = changeType
        }))
        
        let aeroSkirtLabel = "Aero Skirt"
        if trailer.isAeroSkirtEquipped == .True {
            inspectionItems.append(DualStateCell(label: aeroSkirtLabel, changeHandler: { (changeType, sender) -> Void in
                self.inspection.leftAeroSkirt = changeType
            }))
        } else if trailer.isAeroSkirtEquipped == .Unknown {
            inspectionItems.append(TriStateCell(label: aeroSkirtLabel, changeHandler: { (changeType, sender) -> Void in
                self.inspection.leftAeroSkirt = changeType
            }))
        }
        
        inspectionItems.append(DualStateCell(label: "Slider Hose Spring", changeHandler: { (changeType, sender) -> Void in
            self.inspection.leftSliderHoseSpring = changeType
        }))
        inspectionItems.append(MultiLightCell(label: "Yellow Marker Lights", changeHandler: TrailerInspectLeftViewController.buildMultiLightHandler(target: &inspection.leftYellowMarkerLights)))
        inspectionItems.append(SingleLightCell(label: "Red Marker Light", changeHandler: TrailerInspectLeftViewController.buildSingleLightHandler(target: &inspection.leftRedMarkerLights)))
        inspectionItems.append(SingleLightCell(label: "ABS Light", changeHandler : TrailerInspectLeftViewController.buildSingleLightHandler(target: &inspection.leftABSLights)))

        // MARK: - Tire inspection
        inspectionItems.append(InspectionSection(label: "Tire Inspection"))
        
        inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 1)
        if inspection.tireType == .Dual {
            inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 2)
        }
        inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 5)
        if inspection.tireType == .Dual {
            inspectionItems += TrailerInspectLeftViewController.buildTireCells(inspection: &inspection, tireNumber: 6)
        }
        
        if trailer.isPsiEquipped {
            inspectionItems.append(PsiValveCell(label: "PSI Valve", changeHandler: { (changeType, sender) -> Void in
                if changeType == .Closed {
                    self.inspection.psiValveWasClosed = true
                } else if self.inspection.psiValveWasClosed == nil {
                    self.inspection.psiValveWasClosed = false
                }
            }))
        }
        
        // MARK: - Roof inspection
        inspectionItems.append(InspectionSection(label: "Roof Inspection"))
        
        inspectionItems.append(TriStateCell(label : "Roof", segmentTitles : [nil, "Defer", nil], changeHandler: { (changeType, sender) -> Void in
            self.inspection.roof = changeType
        }))
        
        // MARK: - Other
        inspectionItems.append(InspectionSection(label: "Additional Damage"))
        inspectionItems.append(OtherCell(label: "Additional Damage", changeHandler: { (changeType, sender) -> Void in
            self.inspection.leftOther = changeType
        }))
        
        return inspectionItems
    }
    
}
