//
//  Inspection.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class Inspection : NSObject {
    
    // MARK: Child Types
    
    public enum TireType : String{
        case Dual = "Dual"
        case WideBase = "Wide Base"
    }
    
    // Note: These child types must be classes. Passing structs by reference (inout keyword and & operator) seems to not really work as expected. The data isn't stored properly when struct is used.
    public class TcuData {
        public var currentTemperatureFahrenheit : Int?
        public var setTemperatureFahrenheit : Int?
        public var fuelLevel : Float!
        
        public var upperDoors : InspectionTriStateData!
        public var lowerDoors : InspectionTriStateData!
        public var grill : InspectionTriStateData!
        public var belts : InspectionTriStateData!
        public var hoses : InspectionTriStateData!
        
        public var airChute : InspectionTriStateData!
        public var bulkHeads : InspectionTriStateData!
        public var eTrack : InspectionTriStateData!
        
        public var isAntiFreezeLow : TriStateBool = .Unknown
        public var isOilLow : TriStateBool = .Unknown
    }

    public class LightData {
        public var type : LightType!
        public var numLights : Int!
        public var damageData : InspectionTriStateData!
    }
    
    public class TireData {
        public var brand : Company!
        public var otherBrand : String?
        public var depth : Int!
        public var psiValue : Int?
        public var isRecap : Bool!
        public var damageData : InspectionTriStateData!
        
        public var psiHose : InspectionTriStateData?
    }
    
    public class SealData {
        public var sealNumber : String?
        public var sealType : Company?
        public var sealImages : [UIImage]?
    }
    
    // MARK: Initializers
    
    public init(trailer : Trailer) {
        self.trailer = trailer
        
        // The array initializer copies the same reference to each position; so create new instances
        for i in indices(tires) {
            tires[i] = TireData()
        }
        
        for i in indices(seals) {
            seals[i] = SealData()
        }
    }
    
    // MARK: - Preinspection Data
    
    public var trailer : Trailer
    
    public var carrier : Company!
    public var transfer : Company?
    public var usBroker : Company?
    
    public var truckNumber : String!
    public var tripNumber : String?
    
    public var isLoaded : Bool!
    public var tireType : TireType = .Dual
    
    // MARK: - Left side inspection
    
    public var tcuInfo = TcuData()
    public var psiLight : InspectionTriStateData?
    
    public var dotInspectionExpiration : NSDate!
    
    public var leftDollyHandle : InspectionTriStateData!
    public var leftPlacardHolder : InspectionTriStateData!
    public var leftAeroSkirt : InspectionTriStateData?
    public var leftSliderHoseSpring : InspectionTriStateData!
    
    public var leftYellowMarkerLights = LightData()
    public var leftRedMarkerLights = LightData()
    public var leftABSLights = LightData()
    
    public var psiValveWasClosed : Bool?
    
    public var leftOther : InspectionTriStateData = .OK
    
    // MARK: - Rear inspection
    
    public var rearPlacardHolder : InspectionTriStateData!
    public var rearLicensePlate : InspectionTriStateData!
    public var rearLicensePlateLight : InspectionTriStateData!
    
    public var rearRedMarkerLights = LightData()
    public var tailLights = LightData()
    
    public var rearMudFlaps : InspectionTriStateData!
    
    public var rearOther : InspectionTriStateData!
    
    // MARK: - Inside inspection
    
    public var insideFloor : InspectionTriStateData!
    public var insideWalls : InspectionTriStateData!
    public var insideRoof : InspectionTriStateData!
    
    public var gpsCargoSensor : InspectionTriStateData?
    
    // MARK: - Right inspection
    
    public var rightPlacardHolder : InspectionTriStateData!
    public var rightArrowTurningLights : InspectionTriStateData!
    public var rightAeroSkirt : InspectionTriStateData?
    
    public var rightYellowMarkerLights = LightData()
    public var rightRedMarkerLights = LightData()
    
    public var rightOther : InspectionTriStateData!
    
    // MARK: - Front inspection
    
    public var frontPlacardHolder : InspectionTriStateData!
    public var frontVinPlate : InspectionTriStateData!
    public var frontGladHands : InspectionTriStateData!
    public var frontBillBox : InspectionTriStateData!
    public var frontPermitBox : InspectionTriStateData!
    
    public var frontOther : InspectionTriStateData!
    
    // MARK: - Tire and seal data
    
    public var tires = [TireData](count: 8, repeatedValue: TireData())
    public var seals = [SealData](count: 4, repeatedValue: SealData())
    
    // MARK: - Roof
    
    public var roof : InspectionTriStateData!
    
    // MARK: save the data which structure is not supported by GRMustache.swift (dictionaries, enum, struct)
    public var report = [String : AnyObject]()
    
}
