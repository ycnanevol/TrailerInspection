//
//  InspectionSealInfoCell.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class InspectionSealInfoCell : UITableViewCell {
    
    // MARK: InspectionSealInfoCell.CellState
    public class CellState : InspectionTableViewController.CellStateBase {
        
        public override init() {}
        
        public convenience init(mandatory : Bool = false, changeHandler : ((changeType : ChangeType, sender : InspectionSealInfoCell) -> Void)?) {
            self.init()
            
            self.mandatory = mandatory
            
            self.handler = changeHandler
        }
        
        var mandatory = false
        
        var sealNumber : String?
        var sealType : Company?
        var sealImages : [UIImage] = []
        
        var handler : ((ChangeType, InspectionSealInfoCell) -> Void)?
        
        public override func validate() -> Bool {
            if mandatory {
                if sealNumber == nil || sealNumber!.isEmpty {
                    return false
                }
                
                if sealType == nil {
                    return false
                }
                
                if sealImages.isEmpty {
                    return false
                }
            } else if sealNumber != nil && !sealNumber!.isEmpty {
                if sealType == nil {
                    return false
                }
                
                if sealImages.isEmpty {
                    return false
                }
            }
            
            return true
        }
        
        public override func rebuildTableCellForInspectionTable(inspectionTable: InspectionTableViewController, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = inspectionTable.tableView.dequeueReusableCellWithIdentifier("SealInfoCell", forIndexPath: indexPath) as! InspectionSealInfoCell
            
            cell.inspectionTableController = inspectionTable
            cell.state = self
            
            cell.sealNumberTextField.text = sealNumber
            
            return cell
        }
        
    }
    
    public enum ChangeType {
        case SealNumber(sealNumber : String)
        case SealType(sealType : Company)
        case SealImage(sealImages : [UIImage]?)
    }
    
    // MARK: InspectionSealInfoCell members
    @IBOutlet weak var sealNumberTextField: UITextField! {
        didSet {
            sealNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var sealTypeButton : UIButton!
    
    @IBOutlet weak var firstPictureButton: UIButton!
    @IBOutlet weak var secondPictureButton: UIButton!
    @IBOutlet weak var thirdPictureButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    weak var inspectionTableController : InspectionTableViewController!
    weak var state : CellState!
    
    var imagePickerController : UIImagePickerController!
    var sealImages : [UIImage] = []
    
    @IBAction func sealTypeDidTap() {
        inspectionTableController.popoverAnchor = sealTypeButton
        inspectionTableController.popoverSegueDelegate = self
        inspectionTableController.performSegueWithIdentifier("SelectCompanySegue", sender: self)
    }
    
    @IBAction func openCamera(sender: UIButton) {
        
        if sealImages.count > 2 {
            return()
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if imagePickerController == nil {
                imagePickerController = UIImagePickerController()
            }
            
            imagePickerController.sourceType = .Camera
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = .FullScreen
            
            inspectionTableController.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            // TODO(rgrimm): Localize these strings
            let cameraNotAvailableAlertController = UIAlertController(title: "Camera Not Available", message: "The camera is not available on this device.", preferredStyle: .Alert)
            
            cameraNotAvailableAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction : UIAlertAction!) -> Void in
                cameraNotAvailableAlertController.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            inspectionTableController.presentViewController(cameraNotAvailableAlertController, animated: true, completion: nil)
        }
    }
    
    func showImageInButton(image: UIImage, button : UIButton) {
        button.hidden = false
        button.setImage(image, forState: .Normal)
        
        if button === thirdPictureButton {
            cameraButton.hidden = true
        }
    }
}


//MARK: - UINavigationControllerDelegate extension
extension InspectionSealInfoCell : UINavigationControllerDelegate { }

//MARK: - Take photo extension
extension InspectionSealInfoCell : UIImagePickerControllerDelegate {
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            sealImages.append(image)
            state.handler?(ChangeType.SealImage(sealImages: sealImages), self)
            state.sealImages.append(image)
            
            switch sealImages.count {
            case 1: showImageInButton(image, button: secondPictureButton)
            case 2: showImageInButton(image, button: firstPictureButton)
            case 3: showImageInButton(image, button: thirdPictureButton)
            default: if true {}
            }
        }
    }
}

// MARK: - UITextFieldDelegate extension
extension InspectionSealInfoCell : UITextFieldDelegate {
    
    public func textFieldDidEndEditing(textField: UITextField) {
        state.sealNumber = textField.text
        state.handler?(.SealNumber(sealNumber: textField.text), self)
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case sealNumberTextField:
            textField.resignFirstResponder()
        default:
            return false
        }
        
        return true
    }
    
}

// MARK: - InspectionFormValidationDelegate extension
extension InspectionSealInfoCell : InspectionFormValidationDelegate {
    
    public func getValidationPassingState() -> Bool {
        return state.validate()
    }
    
    public func getValidationFailureViews() -> [UIView] {
        var failureViews : [UIView] = []
        
        if state.mandatory {
            if sealNumberTextField.text == nil || sealNumberTextField.text.isEmpty {
                failureViews.append(sealNumberTextField)
            }
            
            if state.sealType == nil {
                failureViews.append(sealTypeButton)
            }
            
            if state.sealImages.isEmpty {
                failureViews.append(cameraButton)
            }
            
        } else {
            if sealNumberTextField.text != nil && !sealNumberTextField.text.isEmpty {
                if state.sealType == nil {
                    failureViews.append(sealTypeButton)
                }
                
                if state.sealImages.isEmpty {
                    failureViews.append(cameraButton)
                }
            }
        }
        
        return failureViews
    }
    
}

// MARK: - InspectionSegueDelegate extension
extension InspectionSealInfoCell : InspectionSegueDelegate {
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destination = segue.destinationViewController as? PopupCompanyPickerViewController {
            destination.companyType = .SealType
            destination.selectedCompany = state.sealType
        }
        
    }
    
    public func prepareForUnwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "CompanySaveUnwindSegue",
            let source = segue.sourceViewController as? PopupCompanyPickerViewController {
                state.sealType = source.selectedCompany
                sealTypeButton.setTitle(state.sealType?.name, forState: .Normal)

                if let company = source.selectedCompany {
                    state.handler?(.SealType(sealType: company), self)
                }
        }
    }
    
}
