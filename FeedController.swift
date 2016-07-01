//
//  FeedController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 6/14/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class FeedController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var uploadSegueButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadSegueButton.layer.borderColor = UIColor(red: 179.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1.0).CGColor
        
        if (self.revealViewController() != nil) {
        settingsButton.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: .TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}