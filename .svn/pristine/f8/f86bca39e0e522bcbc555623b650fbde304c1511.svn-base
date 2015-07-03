//
//  TrailerNumberAndIndicatorCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import UIKit

class TrailerNumberAndIndicatorCell : UITableViewCell {

    @IBOutlet private weak var trailerNumberLabel : UILabel!
    @IBOutlet private weak var aeroSkirtIcon : UIImageView!
    @IBOutlet private weak var aeroSkirtLabel : UILabel!
    @IBOutlet private weak var psiIcon : UIImageView!
    @IBOutlet private weak var psiLabel : UILabel!
    @IBOutlet private weak var gpsIcon : UIImageView!
    @IBOutlet private weak var gpsLabel : UILabel!
    
    var trailerNumber : String = "" {
        didSet {
            trailerNumberLabel.text = "#\(trailerNumber)"
        }
    }
    
    var hasAeroSkirt : Bool = false {
        didSet {
            aeroSkirtIcon.hidden = !hasAeroSkirt
            aeroSkirtLabel.hidden = !hasAeroSkirt
        }
    }

    var hasPsi : Bool = false {
        didSet {
            psiIcon.hidden = !hasPsi
            psiLabel.hidden = !hasPsi
        }
    }
    
    var hasGps : Bool = false {
        didSet {
            gpsIcon.hidden = !hasGps
            gpsLabel.hidden = !hasGps
        }
    }
    
    class func cellForTableView(tableView : UITableView) -> TrailerNumberAndIndicatorCell {
        return tableView.dequeueReusableCellWithIdentifier("TrailerNumberAndIndicators") as! TrailerNumberAndIndicatorCell
    }
    
    class func cellForTableView(tableView : UITableView, trailerNumber : String, hasAeroSkirt : Bool, hasPsi : Bool, hasGps : Bool) -> TrailerNumberAndIndicatorCell {
        let cell = cellForTableView(tableView)
        
        cell.trailerNumber = trailerNumber
        cell.hasAeroSkirt = hasAeroSkirt
        cell.hasPsi = hasPsi
        cell.hasGps = hasGps
        
        return cell
    }
    
}
