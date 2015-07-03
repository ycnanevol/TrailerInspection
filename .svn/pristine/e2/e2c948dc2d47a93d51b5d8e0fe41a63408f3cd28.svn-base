//
//  DamagedImageViewController.swift
//  TrailerInspection
//
//  Created by Jerry Jiang on 21/5/15.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation
import UIKit

public class DamagedImageViewController :  ViewControllerBase, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var damagedImage: UIImageView!
    
    public var picture : UIImage?
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let passedPicture = picture {
            damagedImage.image = picture
        }
    }
}