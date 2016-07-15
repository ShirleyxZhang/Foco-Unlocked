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
import ImagePicker

class SettingsProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointsNumber: UILabel!
    @IBOutlet weak var changeUserEmail: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    
    let usersRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        profileImage!.layer.masksToBounds = false
        profileImage!.layer.borderWidth = 1
        profileImage!.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage!.alpha = 0.3
        //userImage!.backgroundColor = UIColor.lightGrayColor()
        profileImage!.clipsToBounds = true
        
        if (self.revealViewController() != nil) {
            settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        userEmail.text = user!.email!
        let usersEmail = user!.email!
        let email = usersEmail.componentsSeparatedByString(".")[0]
        
        if (user?.photoURL == nil) {
            profileImage.image = UIImage(named: "user.png")
        } else if (user?.photoURL == nil) {
            //profileImage.image = UIImage(data: NSData(contentsOfURL: (user?.photoURL)!)!)!
        }
        
        // Pulls up the number of Points the user has
        self.usersRef.child("users").child("\(email)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.pointsNumber.text = snapshot.value! as? String
            } else {
                self.pointsNumber.text = "0"
            }
        })
        
        // Pulls up the number of Posts the user has
        self.usersRef.child("users").child("\(email)").child("Posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.numberOfPosts.text = "Number of Posts: \(snapshot.value! as! String)"
            } else {
                self.numberOfPosts.text = "Number of Posts: 0"
            }
        })
        
        // Pulls up the number of Liked Posts the user has
        self.usersRef.child("users").child("\(email)").child("Likes").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.numberOfPosts.text = "Liked Posts: \(snapshot.value! as! String)"
            } else {
                self.numberOfPosts.text = "Liked Posts: 0"
            }
        })
    
    }
    
    
    // Function to change the profile of the user
    @IBAction func changeProfileImage(sender: AnyObject) {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        Configuration.doneButtonTitle = "Done"
        Configuration.noImagesTitle = "Sorry! There are no images here!"
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // Function called when user selects wrapper image
    func wrapperDidPress( images: [UIImage]) {
        print("Wrapper Did Press")
    }
    
    // Function called when user selects the done button
    func doneButtonDidPress(images: [UIImage]) {
        print("Done Button Did Press")
        // Might not have the images
        profileImage.image = images[0]
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Function called when the suer selects the cancel button
    func cancelButtonDidPress() {
        print("Cancel Button Did Press")
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