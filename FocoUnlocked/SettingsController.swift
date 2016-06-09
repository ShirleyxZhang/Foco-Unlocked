//
//  SettingsController.swift
//  FocoUnlocked
//
//  View controller for the settings page
//  This will be changed to hold more options
//  Later, users should have the ability to swipe from the right to open the settings page
//
//  Created by WISP on 4/11/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userImage!.layer.borderWidth = 1
        userImage!.layer.cornerRadius = 112.5
        
        let user = FIRAuth.auth()?.currentUser
        userEmail.text = user!.email
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("logout", sender: self)
        print("Logged out :)")
    }
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}