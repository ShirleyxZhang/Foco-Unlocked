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
    
    var imageData: NSData = NSData()
    var decodeImageData: NSData = NSData()
    var decodedImage: UIImage = UIImage()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userImage!.layer.masksToBounds = false
        userImage!.layer.borderWidth = 1
        userImage!.layer.cornerRadius = userImage.frame.size.width / 2
        userImage!.alpha = 0.3
        //userImage!.backgroundColor = UIColor.lightGrayColor()
        userImage!.clipsToBounds = true
        
        let user = FIRAuth.auth()?.currentUser
        if (user != nil) {
        userEmail.text = user!.email
        let usersEmail = user!.email
        let email = usersEmail!.componentsSeparatedByString(".")[0]
        
            self.usersRef.child("users").child("\(email)").child("ProfileImage").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if (!(snapshot.value is NSNull)) {
                    self.userImage!.layer.masksToBounds = false
                    self.userImage!.layer.borderWidth = 1
                    self.userImage!.layer.cornerRadius = self.userImage.frame.size.width / 2
                    self.userImage!.clipsToBounds = true
                    self.decodeImageData = NSData(base64EncodedString: snapshot.value as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    self.decodedImage = UIImage(data: self.decodeImageData)!
                    self.userImage!.image = self.decodedImage
                } else {
                    self.userImage!.layer.masksToBounds = false
                    self.userImage!.layer.borderWidth = 1
                    self.userImage!.layer.cornerRadius = self.userImage.frame.size.width / 2
                    self.userImage!.alpha = 0.3
                    //userImage!.backgroundColor = UIColor.lightGrayColor()
                    self.userImage!.clipsToBounds = true
                    self.userImage.image = UIImage(named: "user.png")
                }
            })
        
        self.usersRef.child("users").child("\(email)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.pointsNumber.text = snapshot.value! as? String
            }
        })
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        let logOut = { (action: UIAlertAction!) -> Void in
            try! FIRAuth.auth()!.signOut()
            self.performSegueWithIdentifier("logout", sender: self)
            print("Logged out :)")
        }
        let alertController = UIAlertController(title: "Log out", message:
            "Are your sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: logOut))
        alertController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}