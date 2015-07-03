//
//  Constants.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-31.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public class Constants {
    
    public enum CompanyType {
        case USBroker
        case MexicanCarrier
        case USCarrier
        case Transfer
        case TireBrand
        // TODO(rgrimm): Refactor to be more general. Seal types aren't really companies
        case SealType
        case Unknown
    }
    
    public static let validationFailTextColor = UIColor(white: 1.0, alpha: 1.0)
    public static let validationFailHighlightColor = UIColor(red: 174.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    public static let animationDuration : NSTimeInterval = 0.5
    
    public static let reportDateFormater : NSDateFormatter! = {
        
        let reportDateFormater = NSDateFormatter()
        reportDateFormater.dateFormat = "MM/dd/yyyy HH:mm"
        
        return reportDateFormater
    }()
    
    public static let monthYearFormater : NSDateFormatter! = {
        
        let reportDateFormater = NSDateFormatter()
        reportDateFormater.dateFormat = "MM/yyyy"
        
        return reportDateFormater
    }()
    
    public static var serviceLinks : [String : String] = [
        // TODO(rgrimm): Get URLs based on environment (and make sure PROD is in https
        // "getToken": "http://dev-sb13-c.wernerds.net/MobileDataServices/05/AuthenticationService.svc/authentication/TrailerInspection"
        "getToken": "http://dev-sb13-mt1.wernerds.net:8080/logistics/services/security/v1/token"
    ]
    
    public static let wernerCompany : Company = Company(id: nil, code: nil, name: NSLocalizedString("WernerEnterprises", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Werner Enterprises", comment: "Localized name of Werner"))
    
    public static let otherCompany : Company = Company(id: nil, code: nil, name: NSLocalizedString("Other", tableName: "GenericCompanies", bundle: .mainBundle(), value: "Other", comment: "Localized name for option to select unlisted company"))
    
    public static let companiesByType : [CompanyType: [Company]] = [
        .USBroker: [
            Company(id: nil, code: nil, name: NSLocalizedString("AmericanDispatch", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "American Dispatch", comment: "Localized name of American Dispatch")),
            Company(id: nil, code: nil, name: NSLocalizedString("ARCCanales", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "ARC Canales", comment: "Localized name of ARC Canales")),
            Company(id: nil, code: nil, name: NSLocalizedString("BorderTransfer", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Border Transfer", comment: "Localized name of Border Transfer")),
            Company(id: nil, code: nil, name: NSLocalizedString("Codex", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Codex", comment: "Localized name of Codex")),
            Company(id: nil, code: nil, name: NSLocalizedString("DaiForwarding", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Dai Forwarding", comment: "Localized name of Dai Forwarding")),
            Company(id: nil, code: nil, name: NSLocalizedString("DelBravo", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Del Bravo", comment: "Localized name of Del Bravo")),
            Company(id: nil, code: nil, name: NSLocalizedString("ErmiloRicher", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Ermilo Richer", comment: "Localized name of Ermilo Richer")),
            Company(id: nil, code: nil, name: NSLocalizedString("Exel", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Exel", comment: "Localized name of Exel")),
            Company(id: nil, code: nil, name: NSLocalizedString("GalvanGroup", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Galvan Group", comment: "Localized name of Galvan Group")),
            Company(id: nil, code: nil, name: NSLocalizedString("GonzalezdeCastilla", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Gonzalez de Castilla", comment: "Localized name of Gonzalez de Castilla")),
            Company(id: nil, code: nil, name: NSLocalizedString("IntransitUSA", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Intransit USA", comment: "Localized name of Intransit USA")),
            Company(id: nil, code: nil, name: NSLocalizedString("Jamco", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Jamco", comment: "Localized name of Jamco")),
            Company(id: nil, code: nil, name: NSLocalizedString("KalischBrokers", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Kalisch Brokers", comment: "Localized name of Kalisch Brokers")),
            Company(id: nil, code: nil, name: NSLocalizedString("LaserFwding", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Laser Fwding", comment: "Localized name of Laser Fwding")),
            Company(id: nil, code: nil, name: NSLocalizedString("PasquelHermanos", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Pasquel Hermanos", comment: "Localized name of Pasquel Hermanos")),
            Company(id: nil, code: nil, name: NSLocalizedString("Ravisa", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Ravisa", comment: "Localized name of Ravisa")),
            Company(id: nil, code: nil, name: NSLocalizedString("RBGroup", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "RB Group", comment: "Localized name of RB Group")),
            Company(id: nil, code: nil, name: NSLocalizedString("SRFwding", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "S R Fwding", comment: "Localized name of S R Fwding")),
            Company(id: nil, code: nil, name: NSLocalizedString("SergioLujan", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Sergio Lujan", comment: "Localized name of Sergio Lujan")),
            Company(id: nil, code: nil, name: NSLocalizedString("TCintl", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "TC intl", comment: "Localized name of TC intl")),
            Company(id: nil, code: nil, name: NSLocalizedString("TransAmericafwding", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Trans-America fwding", comment: "Localized name of Trans-America fwding")),
            Company(id: nil, code: nil, name: NSLocalizedString("Unitex", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Unitex", comment: "Localized name of Unitex")),
            Company(id: nil, code: nil, name: NSLocalizedString("Ventus", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Ventus", comment: "Localized name of Ventus")),
            Company(id: nil, code: nil, name: NSLocalizedString("ZayroLogistics", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Zayro Logistics", comment: "Localized name of Zayro Logistics")),
            Company(id: nil, code: nil, name: NSLocalizedString("ZegoGroup", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Zego Group", comment: "Localized name of Zego Group")),
            Company(id: nil, code: nil, name: NSLocalizedString("ZunigaLogistics", tableName: "BrokerCompanies", bundle: .mainBundle(), value: "Zuniga Logistics", comment: "Localized name of Zuniga Logistics")),
        ],
        .MexicanCarrier: [
            Company(id: nil, code: nil, name: NSLocalizedString("ALA", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "ALA", comment: "Localized name of ALA")),
            Company(id: nil, code: nil, name: NSLocalizedString("Americanos", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Americanos", comment: "Localized name of Americanos")),
            Company(id: nil, code: nil, name: NSLocalizedString("CFM", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "CFM", comment: "Localized name of CFM")),
            Company(id: nil, code: nil, name: NSLocalizedString("Cosio ", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Cosio ", comment: "Localized name of Cosio ")),
            Company(id: nil, code: nil, name: NSLocalizedString("Egoba", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Egoba", comment: "Localized name of Egoba")),
            Company(id: nil, code: nil, name: NSLocalizedString("Elola", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Elola", comment: "Localized name of Elola")),
            Company(id: nil, code: nil, name: NSLocalizedString("Esteban", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Esteban", comment: "Localized name of Esteban")),
            Company(id: nil, code: nil, name: NSLocalizedString("Fema", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Fema", comment: "Localized name of Fema")),
            Company(id: nil, code: nil, name: NSLocalizedString("Flensa", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Flensa", comment: "Localized name of Flensa")),
            Company(id: nil, code: nil, name: NSLocalizedString("Gonzalez", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Gonzalez", comment: "Localized name of Gonzalez")),
            Company(id: nil, code: nil, name: NSLocalizedString("Hercules", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Hercules", comment: "Localized name of Hercules")),
            Company(id: nil, code: nil, name: NSLocalizedString("HG", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "HG", comment: "Localized name of HG")),
            Company(id: nil, code: nil, name: NSLocalizedString("Innovativos ", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Innovativos ", comment: "Localized name of Innovativos ")),
            Company(id: nil, code: nil, name: NSLocalizedString("Oriente", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Oriente", comment: "Localized name of Oriente")),
            Company(id: nil, code: nil, name: NSLocalizedString("Pavi ", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Pavi ", comment: "Localized name of Pavi ")),
            Company(id: nil, code: nil, name: NSLocalizedString("TAO", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "TAO", comment: "Localized name of TAO")),
            Company(id: nil, code: nil, name: NSLocalizedString("TDR", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "TDR", comment: "Localized name of TDR")),
            Company(id: nil, code: nil, name: NSLocalizedString("TLH", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "TLH", comment: "Localized name of TLH")),
            Company(id: nil, code: nil, name: NSLocalizedString("Trucka", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "Trucka", comment: "Localized name of Trucka")),
            Company(id: nil, code: nil, name: NSLocalizedString("TUM", tableName: "MexicanCarrierCompanies", bundle: .mainBundle(), value: "TUM", comment: "Localized name of TUM")),
        ],
        .USCarrier: [
            Company(id: nil, code: nil, name: NSLocalizedString("ARMotorExpress", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "A&R Motor Express", comment: "Localized name of A&R Motor Express")),
            Company(id: nil, code: nil, name: NSLocalizedString("ArmandoRosas", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Armando Rosas", comment: "Localized name of Armando Rosas")),
            Company(id: nil, code: nil, name: NSLocalizedString("BryansExpress", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Bryans Express", comment: "Localized name of Bryans Express")),
            Company(id: nil, code: nil, name: NSLocalizedString("CATrucking", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "CA Trucking", comment: "Localized name of CA Trucking")),
            Company(id: nil, code: nil, name: NSLocalizedString("CITrucking", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "C&I Trucking", comment: "Localized name of C&I Trucking")),
            Company(id: nil, code: nil, name: NSLocalizedString("CEVTransport", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "CEV Transport", comment: "Localized name of CEV Transport")),
            Company(id: nil, code: nil, name: NSLocalizedString("DavanaInternational", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Davana International", comment: "Localized name of Davana International")),
            Company(id: nil, code: nil, name: NSLocalizedString("FACarriersInc", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "F&A Carriers, Inc.", comment: "Localized name of F&A Carriers, Inc.")),
            Company(id: nil, code: nil, name: NSLocalizedString("ForzaTransportation", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Forza Transportation", comment: "Localized name of Forza Transportation")),
            Company(id: nil, code: nil, name: NSLocalizedString("G4Express", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "G4 Express", comment: "Localized name of G4 Express")),
            Company(id: nil, code: nil, name: NSLocalizedString("KONCOTransport", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "KONCO Transport", comment: "Localized name of KONCO Transport")),
            Company(id: nil, code: nil, name: NSLocalizedString("MonykykyTransportation", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Monykyky Transportation", comment: "Localized name of Monykyky Transportation")),
            Company(id: nil, code: nil, name: NSLocalizedString("PSTransport", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "PS Transport", comment: "Localized name of PS Transport")),
            Company(id: nil, code: nil, name: NSLocalizedString("RACarriers", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "R&A Carriers", comment: "Localized name of R&A Carriers")),
            Company(id: nil, code: nil, name: NSLocalizedString("RabcoTrucking", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "Rabco Trucking", comment: "Localized name of Rabco Trucking")),
            Company(id: nil, code: nil, name: NSLocalizedString("TATransportation", tableName: "USCarrierCompanies", bundle: .mainBundle(), value: "TA Transportation", comment: "Localized name of TA Transportation")),
        ],
        .Transfer: [
            Company(id: nil, code: nil, name: NSLocalizedString("ALLBRAND", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "ALLBRAND", comment: "Localized name of ALLBRAND")),
            Company(id: nil, code: nil, name: NSLocalizedString("DRACO", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "DRACO", comment: "Localized name of DRACO")),
            Company(id: nil, code: nil, name: NSLocalizedString("FEMA", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "FEMA", comment: "Localized name of FEMA")),
            Company(id: nil, code: nil, name: NSLocalizedString("GARLAND", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "GARLAND", comment: "Localized name of GARLAND")),
            Company(id: nil, code: nil, name: NSLocalizedString("INDIANA", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "INDIANA", comment: "Localized name of INDIANA")),
            Company(id: nil, code: nil, name: NSLocalizedString("ITS", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "ITS", comment: "Localized name of ITS")),
            Company(id: nil, code: nil, name: NSLocalizedString("JASSO", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "JASSO", comment: "Localized name of JASSO")),
            Company(id: nil, code: nil, name: NSLocalizedString("JBR", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "JBR", comment: "Localized name of JBR")),
            Company(id: nil, code: nil, name: NSLocalizedString("JMTRANSPORT", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "JM TRANSPORT", comment: "Localized name of JM TRANSPORT")),
            Company(id: nil, code: nil, name: NSLocalizedString("LCI", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "LCI", comment: "Localized name of LCI")),
            Company(id: nil, code: nil, name: NSLocalizedString("LURSAN", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "LURSAN", comment: "Localized name of LURSAN")),
            Company(id: nil, code: nil, name: NSLocalizedString("OCTRUCKING", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "OC TRUCKING", comment: "Localized name of OC TRUCKING")),
            Company(id: nil, code: nil, name: NSLocalizedString("REFLEN", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "REFLEN", comment: "Localized name of REFLEN")),
            Company(id: nil, code: nil, name: NSLocalizedString("ROQUIN", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "ROQUIN", comment: "Localized name of ROQUIN")),
            Company(id: nil, code: nil, name: NSLocalizedString("SCL", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "SCL", comment: "Localized name of SCL")),
            Company(id: nil, code: nil, name: NSLocalizedString("TIL", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "TIL", comment: "Localized name of TIL")),
            Company(id: nil, code: nil, name: NSLocalizedString("TRUCKA", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "TRUCKA", comment: "Localized name of TRUCKA")),
            Company(id: nil, code: nil, name: NSLocalizedString("TUM", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "TUM", comment: "Localized name of TUM")),
            Company(id: nil, code: nil, name: NSLocalizedString("VIPE ", tableName: "TransferCarrierCompanies", bundle: .mainBundle(), value: "VIPE ", comment: "Localized name of VIPE ")),
        ],
        .TireBrand: [
            Company(id: nil, code: nil, name: NSLocalizedString("Bridgestone", tableName: "TireBrandCompanies", bundle: .mainBundle(), value: "Bridgestone", comment: "Localized name for Bridgestone")),
            Company(id: nil, code: nil, name: NSLocalizedString("Dunlop", tableName: "TireBrandCompanies", bundle: .mainBundle(), value: "Dunlop", comment: "Localized name for Dunlop")),
            Company(id: nil, code: nil, name: NSLocalizedString("Goodyear", tableName: "TireBrandCompanies", bundle: .mainBundle(), value: "Goodyear", comment: "Localized name for Goodyear")),
            Company(id: nil, code: nil, name: NSLocalizedString("Hankook", tableName: "TireBrandCompanies", bundle: .mainBundle(), value: "Hankook", comment: "Localized name for Hankook")),
            Constants.otherCompany,
        ],
        .SealType: [
            Company(id: nil, code: nil, name: NSLocalizedString("Aluminum", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Aluminum", comment: "Localized name for Aluminum")),
            Company(id: nil, code: nil, name: NSLocalizedString("Bolt", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Bolt", comment: "Localized name for Bolt")),
            Company(id: nil, code: nil, name: NSLocalizedString("Cable", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Cable", comment: "Localized name for Cable")),
            Company(id: nil, code: nil, name: NSLocalizedString("Plastic", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Plastic", comment: "Localized name for Plastic")),
            Company(id: nil, code: nil, name: NSLocalizedString("PlasticStrip", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Plastic String", comment: "Localized name for Plastic Strip")),
            Company(id: nil, code: nil, name: NSLocalizedString("TapeSeal", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "Tape Seal", comment: "Localized name for Tape Seal")),
            Company(id: nil, code: nil, name: NSLocalizedString("US Customs", tableName: "SealTypeCompanies", bundle: .mainBundle(), value: "US Customs", comment: "Localized name for US Customs")),
        ],
    ]
    
}
