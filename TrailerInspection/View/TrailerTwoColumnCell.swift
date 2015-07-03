//
//  TrailerTwoColumnCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-30.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import UIKit

class TrailerTwoColumnCell : UITableViewCell {
    
    @IBOutlet private weak var columnOneLabel: UILabel!
    @IBOutlet private weak var columnOneValue: UILabel!
    @IBOutlet private weak var columnTwoLabel: UILabel!
    @IBOutlet private weak var columnTwoValue: UILabel!
    
    private lazy var uiColumnLabels : [UILabel] = {
        return [ self.columnOneLabel, self.columnTwoLabel ]
    }()
    
    private lazy var uiColumnValues : [UILabel] = {
        return [ self.columnOneValue, self.columnTwoValue ]
    }()
    
    var columnLabels : [String] = [] {
        didSet {
            if columnOneLabel == nil {
                return
            }
            
            updateDisplayCollection(uiColumnLabels, texts: columnLabels)
        }
    }
    
    var columnValues : [String] = [] {
        didSet {
            if columnOneValue == nil {
                return
            }
            
            updateDisplayCollection(uiColumnValues, texts: columnValues)
        }
    }
    
    private func updateDisplayCollection(uiLabels : [UILabel], texts : [String]) {
        let numTexts = texts.count
        
        for (index, uiLabel) in enumerate(uiLabels) {
            if index < numTexts {
                uiLabel.text = texts[index]
                uiLabel.hidden = false
            } else {
                uiLabel.hidden = true
            }
        }
    }
    
    class func cellForTableView(tableView : UITableView) -> TrailerTwoColumnCell {
        return tableView.dequeueReusableCellWithIdentifier("TwoColumnInfo") as! TrailerTwoColumnCell
    }
    
    class func cellForTableView(tableView : UITableView, columnLabels : [String], columnValues : [String]) -> TrailerTwoColumnCell {
        let cell = cellForTableView(tableView)
        
        cell.columnLabels = columnLabels
        cell.columnValues = columnValues
        
        return cell
    }
    
}
