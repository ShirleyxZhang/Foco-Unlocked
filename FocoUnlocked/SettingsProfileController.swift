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
    
    var imageData: NSData = NSData()
    var decodeImageData: NSData = NSData()
    var decodedImage: UIImage = UIImage()
    
    let usersRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        userEmail.text = user!.email!
        let usersEmail = user!.email!
        let email = usersEmail.componentsSeparatedByString(".")[0]
        
        // Pulls up the profile image the user has
        self.usersRef.child("users").child("\(email)").child("ProfileImage").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.profileImage!.layer.masksToBounds = false
                self.profileImage!.layer.borderWidth = 1
                self.profileImage!.layer.cornerRadius = self.profileImage.frame.size.width / 2
                self.profileImage!.clipsToBounds = true
                self.decodeImageData = NSData(base64EncodedString: snapshot.value as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                self.decodedImage = UIImage(data: self.decodeImageData)!
                self.profileImage!.image = self.decodedImage
            } else {
                self.profileImage!.layer.masksToBounds = false
                self.profileImage!.layer.borderWidth = 1
                self.profileImage!.layer.cornerRadius = self.profileImage.frame.size.width / 2
                self.profileImage!.alpha = 0.3
                //userImage!.backgroundColor = UIColor.lightGrayColor()
                self.profileImage!.clipsToBounds = true
                self.profileImage.image = UIImage(named: "user.png")
            }
        })
        
        if (self.revealViewController() != nil) {
            settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        
        let user = FIRAuth.auth()?.currentUser
        
        let usersEmail = user!.email!
        let email = usersEmail.componentsSeparatedByString(".")[0]

        self.imageData = UIImageJPEGRepresentation(images[0], 0.1)!
        let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        self.usersRef.child("users").child("\(email)").child("ProfileImage").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                self.usersRef.child("users").child("\(email)").child("ProfileImage").setValue(String(base64String))
            } else {
                self.usersRef.child("users").child("\(email)").child("ProfileImage").setValue(String(base64String))
            }
        })
        
        profileImage.image = images[0]
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Function called when the suer selects the cancel button
    func cancelButtonDidPress() {
        print("Cancel Button Did Press")
    }
    
    @IBAction func deleteAccount(sender: AnyObject) {
        var user = FIRAuth.auth()?.currentUser
        
        let deleteAccount = { (action: UIAlertAction!) -> Void in
            print("fdsafdsa")
            user?.deleteWithCompletion { error in
                if let error = error {
                    let alertController = UIAlertController(title: "Error Occured", message:
                        "Not able to delete the account", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                } else {
                    let alertController = UIAlertController(title: "Deletion Successful", message:
                        "You account has been deleted", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                }
                self.navigationController?.popViewControllerAnimated(true)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        let alertController = UIAlertController(title: "Delete Account", message:
            "Are your sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: deleteAccount))
        self.presentViewController(alertController, animated: true, completion: nil)
        print("Step back")
        
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