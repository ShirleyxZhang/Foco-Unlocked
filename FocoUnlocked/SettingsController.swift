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
    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var pointsNumber: UILabel!
    
    let usersRef = FIRDatabase.database().reference()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userImage!.layer.masksToBounds = false
        userImage!.layer.borderWidth = 1
        userImage!.layer.cornerRadius = userImage.frame.size.width / 2
        userImage!.alpha = 0.3
        //userImage!.backgroundColor = UIColor.lightGrayColor()
        userImage!.clipsToBounds = true
        
        let user = FIRAuth.auth()?.currentUser
        userEmail.text = user!.email
        let usersEmail = user!.email
        let email = usersEmail!.componentsSeparatedByString(".")[0]
        
        if (user?.photoURL == nil) {
            userImage.image = UIImage(named: "user.png")
        } else if (user?.photoURL == nil) {
            //userImage.image = user?.photoURL
        }
        
        self.usersRef.child("users").child("\(email)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.pointsNumber.text = snapshot.value! as? String
            }
        })
        
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