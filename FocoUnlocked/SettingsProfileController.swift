//
//  SettingsProfileController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 6/8/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointsNumber: UILabel!
    @IBOutlet weak var changeUserEmail: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    
    let usersRef = FIRDatabase.database().reference()
    
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
        
        let user = FIRAuth.auth()?.currentUser
        userEmail.text = user!.email!
        let usersEmail = user!.email!
        let email = usersEmail.componentsSeparatedByString(".")[0]
        
        if (user?.photoURL == nil) {
            profileImage.image = UIImage(named: "user.png")
        } else if (user?.photoURL == nil) {
            //profileImage.image = user?.photoURL
        }
        
        self.usersRef.child("users").child("\(email)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.pointsNumber.text = snapshot.value! as? String
            }
        })
    
    }
    
    
    // Function to change the profile of the user
    @IBAction func changeProfileImage(sender: AnyObject) {
            let cameraSelect = { (action: UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
        let gallerySelect = { (action: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
            let alertController = UIAlertController(title: "Profile Image", message:
                "How do you want to grab your profile picture?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: cameraSelect))
            alertController.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default,handler: gallerySelect))
            self.presentViewController(alertController, animated: true, completion: nil)
            print("Step back")

    }
    
    // Function to choose an image from the Photo Library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // Function to take the user back to the previous page
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}