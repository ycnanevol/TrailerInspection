//
//  InspectionTableViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-03.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionTableViewController : ScrollingViewControllerBase {
    
    // MARK: InspectionTableViewController.CellStateBase
    public class CellStateBase {
        
        public init() {}
        
        public func validate() -> Bool {
            WernerLog("Unimplemented vaildation in CellState; defaulting to false")
            return false
        }
        
        public func rebuildTableCellForInspectionTable(inspectionTable : InspectionTableViewController, forIndexPath indexPath : NSIndexPath) -> UITableViewCell {
            WernerLog("Unimplemented rebuildTableCell(); defaulting to unknown inspection cell")
            return inspectionTable.tableView.dequeueReusableCellWithIdentifier("UnknownInspectionCell", forIndexPath: indexPath) as! UITableViewCell
        }
    }
    
    // MARK: InspectionTableViewController.CellStateSection
    public class CellStateSection : CellStateBase {
        
        public override init() {}
        
        public convenience init(label : String) {
            self.init()
            
            self.labelText = label
        }
        
        var labelText : String = ""
    }
    
    // MARK: InspectionTableViewController members
    @IBOutlet public weak var tableView: UITableView!
    
    var popoverAnchor : UIView!
    var popoverSegueDelegate : InspectionSegueDelegate?
    
    // Cache the cells so they don't disappear/regenerate/lose data when scrolled off screen
    var cellSectionTitles : [String] = []
    var cellCache : [NSIndexPath : CellStateBase] = [:]
    
    var inspectionItems : [CellStateBase] = [] {
        didSet {
            var currentSection = 0
            var currentRow = 0
            cellSectionTitles = []
            
            if inspectionItems[0] as? CellStateSection == nil {
                cellSectionTitles.append("")
            } else {
                currentSection--
            }
            
            for (index, cell) in enumerate(inspectionItems) {
                if let section = cell as? CellStateSection {
                    currentSection = cellSectionTitles.endIndex
                    cellSectionTitles.append(section.labelText)
                    currentRow = 0
                } else {
                    cellCache[NSIndexPath(forRow: currentRow, inSection: currentSection)] = cell
                    currentRow++
                }
            }
            
            tableView?.reloadData()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Explicitly set these so that rotation will respect different cell heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        popoverSegueDelegate?.prepareForSegue?(segue, sender: sender)
    }
    
    @IBAction func prepareForUnwindSegue(segue : UIStoryboardSegue) {
        if let source = segue.sourceViewController as? UIViewController {
            if !source.isBeingDismissed() {
                source.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.popoverSegueDelegate?.prepareForUnwindSegue?(segue)
                    return
                })
            } else {
                popoverSegueDelegate?.prepareForUnwindSegue?(segue)
            }
        }
    }
}

// MARK: - DynamicAnchorPopoverSegueDelegate extension
extension InspectionTableViewController : DynamicAnchorPopoverSegueDelegate {
    public func dynamicAnchorRectForSegue(segue: DynamicAnchorPopoverSegue) -> CGRect {
        return popoverAnchor.frame
    }
    
    public func dynamicAnchorViewForSegue(segue: DynamicAnchorPopoverSegue) -> UIView? {
        return popoverAnchor.superview
    }
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionTableViewController : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        for cell in cellCache.values {
            if !cell.validate() {
                return false
            }
        }
        
        return true
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failedViews : [UIView] = []
        
        for cell in tableView.visibleCells() {
            if let cellDelegate = cell as? InspectionFormValidationDelegate {
                failedViews += cellDelegate.getValidationFailureViews()
            }
        }

        return failedViews
    }
    
}

// MARK: - UITableViewDataSource extension
extension InspectionTableViewController : UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView : UITableView) -> Int {
        return cellSectionTitles.count
    }
    
    public func tableView(tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        return cellCache.keys.filter { (indexPath) -> Bool in
            indexPath.section == section
        }.array.count
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellSectionTitles[section]
    }
    
    public func tableView(tableView : UITableView, cellForRowAtIndexPath indexPath : NSIndexPath) -> UITableViewCell {
        if let cachedCell = cellCache[indexPath] {
            return cachedCell.rebuildTableCellForInspectionTable(self, forIndexPath: indexPath)
        }
        
        return tableView.dequeueReusableCellWithIdentifier("UnknownInspectionCell", forIndexPath: indexPath) as! UITableViewCell
    }
    
}

// MARK: - InspectionSegueDelegate protocol
@objc public protocol InspectionSegueDelegate {

    optional func prepareForSegue(segue : UIStoryboardSegue, sender : AnyObject?)
    optional func prepareForUnwindSegue(segue : UIStoryboardSegue)

}
