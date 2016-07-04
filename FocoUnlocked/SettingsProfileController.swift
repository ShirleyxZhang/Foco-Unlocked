//
//  SettingsProfileController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 6/8/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class SettingsProfileController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointsNumber: UILabel!
    @IBOutlet weak var changeUserEmail: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        profileImage!.layer.masksToBounds = false
        profileImage!.layer.borderWidth = 1
        profileImage!.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage!.alpha = 0.3
        //userImage!.backgroundColor = UIColor.lightGrayColor()
        profileImage!.clipsToBounds = true
        
        if (self.revealViewController() != nil) {
            settingsButton.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    @IBAction func changeProfileImage(sender: AnyObject) {
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}