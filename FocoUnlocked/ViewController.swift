//
//  ViewController.swift
//  FocoUnlocked
//
//  The view controller that defines the Upload Page
//
//  Created by WISP on 3/25/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Firebase
import ImagePicker

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ImagePickerDelegate{
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    // Elements that show up on the Upload page
    @IBOutlet var naviBar: UIView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemDesc: UITextView!
    @IBOutlet var itemTags: UITextField!
    
    @IBOutlet weak var imageNoteLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet var uploadButton: UIButton!
    
    //var photoImageView: UIImageView!
    
    var postsList: Array<Post> = [Post]()
    
    var imageData: NSData = NSData()
    
    let usersRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemDesc!.layer.borderColor = UIColor.orangeColor().CGColor
        
        if (self.revealViewController() != nil) {
        settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        // Adding attributes to the item's description box
        itemDesc!.layer.borderWidth = 1
        itemDesc!.layer.borderColor = UIColor.grayColor().CGColor
        
        /*self.photoImageView = UIImageView(frame: CGRectMake(0, 111, view.frame.size.width, view.frame.size.height / 3.7))*/
        self.photoImageView.backgroundColor = UIColor.lightGrayColor()
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: itemName.frame.size.height - width, width: itemName.frame.size.width, height: itemName.frame.size.height)
        
        border.borderWidth = width
        itemName.layer.addSublayer(border)
        itemName.layer.masksToBounds = true   
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.openCameraButton(_:)))
        photoImageView.userInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    // Function to open the Camera Button
    @IBAction func openCameraButton(sender: AnyObject) {
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
        photoImageView.image = images[0]
        imageLabel.hidden = true
        imageNoteLabel.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Function called when the suer selects the cancel button
    func cancelButtonDidPress() {
        print("Cancel Button Did Press")
    }
    
    // Keyboard goes away after you tap somewhere else
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // Implements the uploadButton
    @IBAction func uploadButton(sender: AnyObject) {
        
        let Posts = FIRDatabase.database().reference()
        
        var title: Bool = false
        var desc: Bool = false
        let itemNameCheck: String = itemName.text!
        let itemDescCheck: String = itemDesc.text!
        
        /*var userPoints: Int = 0*/
        
        if itemNameCheck.characters.count >= 4 {
            title = true
        }
        if itemDescCheck.characters.count >= itemNameCheck.characters.count {
            desc = true
        }
        
        // Handles incorrect uploads
        if title == true && desc == false {
            let alertController = UIAlertController(title: "Upload Error", message:
                "Description information is too short", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if title == false && desc == true {
            let alertController = UIAlertController(title: "Upload Error", message:
                "Item Name is too short", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if title == false && desc == false {
            let alertController = UIAlertController(title: "Upload Error", message:
                "Item Name and Description information are too short", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else { // If the user enters all the necessary information, the post will be uploaded to the database
            if photoImageView.image != nil {
                
                if itemTags != nil {
                    let user = FIRAuth.auth()?.currentUser
                    let email: String! = user!.email
                    let userEmail = email.componentsSeparatedByString(".")[0]
                    var author: String = ""
                    self.usersRef.child("\(userEmail)").child("Username").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if (!(snapshot.value is NSNull)) {
                            author = (snapshot.value as! String)
                        } else {
                            author = email
                        }
                    })
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    let newPost: Post = Post(user: author, title: itemName.text!, description: itemDesc.text!, image: base64String, tagsString: itemTags.text!)
                    postsList.append(newPost)
                    Posts.child("users").child("\(userEmail)").child("Posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if (!(snapshot.value is NSNull)) {
                            var pointsNumberString = Int(snapshot.value! as! String)
                            pointsNumberString = pointsNumberString! + 1
                            self.usersRef.child("users").child("\(userEmail)").child("Posts").setValue(String(pointsNumberString!))
                        } else {
                            let pointsNumberString : String! = "1"
                            self.usersRef.child("users").child("\(userEmail)").child("Posts").setValue(pointsNumberString)
                        }
                    })
                    Posts.child("posts").child(newPost.getIdString()).setValue(newPost.toArray())
                    
                    let alertController = UIAlertController(title: "Successful Upload", message:
                        "Your item is now on the public field!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    /*self.usersRef.child("users").child(userEmail).observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                        let postDict = snapshot.value as? [String : AnyObject]
                        if (postDict != nil) {
                            for object in postDict! {
                                let key = object.0
                                let obj = String(object.1)
                                if (key == "Points") {
                                    userPoints = Int(obj)!
                                    userPoints++
                                    print("userPoints: \(userPoints)")
                                } else if (key != "Points") {
                                }
                            }
                        }
                    })
                    self.usersRef.child("users").child("\(userEmail)").child("Points").setValue(String(userPoints))*/
                    
                }
                else if itemTags == nil {
                    let user = FIRAuth.auth()?.currentUser
                    let email: String! = user!.email
                    let userEmail = email.componentsSeparatedByString(".")[0]
                    var author: String = ""
                    self.usersRef.child("\(userEmail)").child("Username").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if (!(snapshot.value is NSNull)) {
                            author = (snapshot.value as! String)
                        } else {
                            author = email
                        }
                    })
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    let newPost: Post = Post(user: author, title: itemName.text!, description: itemDesc.text!, image: base64String)
                    postsList.append(newPost)
                    Posts.child("posts").child(newPost.getIdString()).setValue(newPost.toArray())
                    navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Successful Upload", message:
                        "You item is now on the public field!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                }
            }
            else {
                let alertController = UIAlertController(title: "Upload Error", message:
                    "Attach a photo of your item", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Checks to see if the user has enter information
    // If the user did, then the program will double check before popping to previous page
    // I the user didn't, then the program will pop to the previous page
    @IBAction func cancelButton(sender: AnyObject) {
        var title: Bool = false
        var desc: Bool = false
        let itemNameCheck: String = itemName.text!
        let itemDescCheck: String = itemDesc.text!
        
        if itemNameCheck.characters.count >= 1 {
        title = true
        }
        if itemDescCheck.characters.count >= itemNameCheck.characters.count && itemDescCheck.characters.count != 0 {
        desc = true
        }
        
        if (title == true || desc == true) {
            
        let discardView = { (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        let alertController = UIAlertController(title: "Discard Post", message:
        "Are your sure you want to give up on your creation?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.Default, handler: discardView))
        self.presentViewController(alertController, animated: true, completion: nil)
            print("Step back")
        
        } else {
            self.navigationController?.popViewControllerAnimated(true)
            print("Step back")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
