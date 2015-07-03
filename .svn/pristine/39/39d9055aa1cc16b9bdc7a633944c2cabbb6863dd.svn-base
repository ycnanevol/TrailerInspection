//
//  LoginViewController.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-03-26.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import UIKit

class LoginViewController : ScrollingViewControllerBase {
    
    static let localizedLoginFailure = NSLocalizedString("LoginFailure", tableName: "LoginView", bundle: .mainBundle(), value: "Login Failure", comment: "Title for alert that indicates login failure")
    static let localizedOkAction = NSLocalizedString("OkAction", tableName: "LoginView", bundle: .mainBundle(), value: "OK", comment: "Only button for alert that indicates login failure")
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.analyticsManager.screenDidAppear("LoginPage")
        
        usernameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate.analyticsManager.screenWillDisappear("LoginPage")
    }
    
    @IBAction func performLogin() {
        view.endEditing(true)
        
        self.showModalActivity {
            self.serviceManager.performLogin(username: self.usernameTextField.text, password: self.passwordTextField.text) { (success : Bool, message : String?) in
                self.hideModalActivity {
                    if success {
                        self.appDelegate.analyticsManager.eventDidHappen("LoginSuccess")
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.appDelegate.analyticsManager.eventDidHappen("LoginFailure")
                        
                        let alertController = UIAlertController(title: LoginViewController.localizedLoginFailure, message: message, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: LoginViewController.localizedOkAction, style: .Default) { (action : UIAlertAction!) -> Void in
                            self.usernameTextField.becomeFirstResponder()
                            })
                        
                        #if DEBUG
                            alertController.addAction(UIAlertAction(title: "Bypass", style: .Default) { (action : UIAlertAction!) -> Void in
                                self.serviceManager.availableLinks = [
                                    "getTrailer": NSURL(string: "http://dev-sb13-mt1.wernerds.net:8080/logistics/services/equipment/v1/trailer")!,
                                ]
                                self.serviceManager.currentAuthToken = Token(value: "Dummy Token", displayName: "Login Bypassed", email: "SCRUM_Mobile@werner.com")
                                self.dismissViewControllerAnimated(true, completion: nil)
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
        let controller = UIAlertController(title: "Logging In", message: nil, preferredStyle: .Alert)
        
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
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            performLogin()
        default:
            return false;
        }
        
        return true;
    }
    
}
