//
//  TrailerSearchViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import UIKit
import CoreData

public class TrailerSearchViewController : ViewControllerBase {
    
    static let localizedLookupFailure = NSLocalizedString("LookupFailure", tableName: "SearchView", bundle: .mainBundle(), value: "Trailer Lookup Failure", comment: "Title for alert that indicates trailer lookup failure")
    static let localizedOkAction = NSLocalizedString("OkAction", tableName: "SearchView", bundle: .mainBundle(), value: "OK", comment: "Only button for alert that indicates trailer lookup failure")
    static let localizedPrintBlankForm = NSLocalizedString("PrintEmptyForm", tableName: "SearchView", bundle: .mainBundle(), value: "Print Empty Inspection Form", comment: "Text for the menu item allowing the user to print a blank inspection form")
    
    @IBOutlet weak var trailerNumberTextField: UITextField!
    @IBOutlet weak var lastSixVinTextField: UITextField!
    
    var trailerInfo : Trailer?
    
    public override func viewWillAppear(animated : Bool) {
        super.viewWillAppear(animated)
        
        trailerNumberTextField.text = ""
        lastSixVinTextField.text = ""
        
        if let navController = navigationController as? TrailerInspectionNavController {
            navController.statusText = ""
        }
    }
    
    public override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("TrailerSearch", withNewSession: true)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("TrailerSearch")
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let destination = segue.destinationViewController as? InspectionViewControllerBase {
            if let trailerInfo = trailerInfo {
                destination.trailer = trailerInfo
            } else {
                // Don't avoid this crash; we will want Crashlytics/Xcode to dump a stack trace so we can fix it ASAP
                WernerLog("Trailer is nil when advancing to inspection page! Expect a crash in 3... 2... 1...")
            }
        }
    }
    
    @IBAction func performSearch() {
        view.endEditing(true)
        
        showModalActivity {
            self.serviceManager.getTrailerByTrailerNumberAndLastSixVin(trailerNumber: self.trailerNumberTextField.text, lastSixVin: self.lastSixVinTextField.text) { (trailer, message) -> Void in
                self.hideModalActivity {
                    if let trailer = trailer {
                        self.appDelegate.analyticsManager.eventDidHappen("TrailerLookupSuccess")
                        self.trailerInfo = trailer
                        self.performSegueWithIdentifier("TrailerInfoSegue", sender: self)
                    } else {
                        self.appDelegate.analyticsManager.eventDidHappen("TrailerLookupFailure")
                        
                        let alertController = UIAlertController(title: TrailerSearchViewController.localizedLookupFailure, message: message, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: TrailerSearchViewController.localizedOkAction, style: .Default) { (action : UIAlertAction!) -> Void in
                            self.trailerNumberTextField.becomeFirstResponder()
                            return
                        })
                        
                        #if DEBUG
                            alertController.addAction(UIAlertAction(title: "Bypass", style: .Default) { (action : UIAlertAction!) -> Void in
                                var buildAndSegueFakeData = { (trailerType : TrailerType, trailerNumber : String, trailerVin : String, withAeroSkirt : TriStateBool, withPsi : TriStateBool, withGps : TriStateBool) -> Void in
                                    
                                    var mockInfo = Trailer()
                                    
                                    mockInfo.trailerType = trailerType
                                    mockInfo.trailerNumber = trailerNumber
                                    mockInfo.vin = trailerVin

                                    mockInfo.make = "WAB"
                                    mockInfo.model = "Trailer?"
                                    mockInfo.modelYear = "2010"
                                    
                                    mockInfo.isAeroSkirtEquipped = withAeroSkirt
                                    mockInfo.isPsiEquipped = withPsi
                                    mockInfo.isGpsEquipped = withGps
                                    
                                    mockInfo.licenseNumber = "ABC123"
                                    mockInfo.licenseState = "NE"
                                    
                                    self.trailerInfo = mockInfo
                                    self.performSegueWithIdentifier("TrailerInfoSegue", sender: self)
                                }
                                
                                let selectFakeDataController = UIAlertController(title: "Select Fake Data Set", message: "Select fake data to use for inspection", preferredStyle: .ActionSheet)
                                
                                selectFakeDataController.addAction(UIAlertAction(title: "Van w/ PSI", style: .Default, handler: { (action : UIAlertAction!) -> Void in
                                    buildAndSegueFakeData(.Van, "12345", "1JJV532B8FLvanpsi", .Unknown, .True, .Unknown)
                                }))
                                
                                selectFakeDataController.addAction(UIAlertAction(title: "Van w/ AeroSkirt", style: .Default, handler: { (action : UIAlertAction!) -> Void in
                                    buildAndSegueFakeData(.Van, "00000", "1JJV532B8FLvanWas", .True, .False, .Unknown)
                                }))
                                
                                selectFakeDataController.addAction(UIAlertAction(title: "TCU w/ PSI+GPS", style: .Default, handler: { (action : UIAlertAction!) -> Void in
                                    buildAndSegueFakeData(.TCU, "54321", "1JJV532B8FLtcupsi", .Unknown, .True, .True)
                                }))
                                
                                selectFakeDataController.addAction(UIAlertAction(title: "TCU w/ none", style: .Default, handler: { (action : UIAlertAction!) -> Void in
                                    buildAndSegueFakeData(.TCU, "98765", "1JJV532B8FL893962", .False, .False, .False)
                                }))
                                
                                selectFakeDataController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                                
                                self.presentViewController(selectFakeDataController, animated: true, completion: nil)
                            })
                        #endif
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: Modal activity indicator
    let modalActivityController : UIAlertController = {
        // TODO(rgrimm): Localize the strings
        let controller = UIAlertController(title: "Searching for Trailer", message: nil, preferredStyle: .Alert)
        
        // TODO(rgrimm): Add cancel support?
        
        return controller
    }()
    
    func showModalActivity(completion : (() -> Void)? = nil) {
        presentViewController(modalActivityController, animated: true, completion: completion)
    }
    
    func hideModalActivity(completion : (() -> Void)? = nil) {
        modalActivityController.dismissViewControllerAnimated(true, completion: completion)
    }

}

// MARK: - UITextFieldDelegate extension
extension TrailerSearchViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case trailerNumberTextField:
            lastSixVinTextField.becomeFirstResponder()
        case lastSixVinTextField:
            lastSixVinTextField.resignFirstResponder()
            performSearch()
        default:
            return false;
        }
        
        return true;
    }

}

// MARK: - ProfileMenuDataSource extension
extension TrailerSearchViewController : ProfileMenuDataSource {
    
    public var additionalProfileMenuItems : [UIAlertAction] {
        var actions : [UIAlertAction] = []
        
        #if DEBUG
            actions.append(UIAlertAction(title: "Prefill with VAN", style: .Default, handler: { (alertAction) -> Void in
                self.trailerNumberTextField.text = "34454"
                self.lastSixVinTextField.text = "007479"
            }))
            
            actions.append(UIAlertAction(title: "Prefill with TCU", style: .Default, handler: { (alertAction) -> Void in
                self.trailerNumberTextField.text = "28259"
                self.lastSixVinTextField.text = "875387"
            }))
        #endif
        
        actions.append(UIAlertAction(title: TrailerSearchViewController.localizedPrintBlankForm, style: .Default, handler: { (alertAction) -> Void in
            self.trailerInfo = Trailer()
            self.performSegueWithIdentifier("PrintPreviewSegue", sender: self)
        }))
        
        return actions
    }
    
}
