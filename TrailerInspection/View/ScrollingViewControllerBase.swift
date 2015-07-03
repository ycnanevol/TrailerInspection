//
//  ScrollingViewControllerBase.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-04-16.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class ScrollingViewControllerBase : ViewControllerBase {
    
    weak var scrollView : UIScrollView!
    
    var preKeyboardBottomInset : CGFloat = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                if let tabBarOpaque = tabBarController?.tabBar.opaque where !tabBarOpaque,
                    let tabBarHeight = tabBarController?.tabBar.frame.height {
                        preKeyboardBottomInset += tabBarHeight
                }
                
                if let toolbarOpaque = navigationController?.toolbar.opaque where !toolbarOpaque,
                    let toolbarHeight = navigationController?.toolbar.frame.height {
                        preKeyboardBottomInset += toolbarHeight
                }
                
                scrollView.contentInset.bottom = preKeyboardBottomInset
                
                self.scrollView = scrollView
                break
            }
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Bypass scroll adjustments inside popovers
        if self.popoverPresentationController != nil {
            return
        }
        
        if scrollView != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if scrollView != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    func keyboardWillShow(notification : NSNotification) {
        preKeyboardBottomInset = scrollView.contentInset.bottom
        
        if let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        scrollView.contentInset.bottom = preKeyboardBottomInset
    }
    
}
