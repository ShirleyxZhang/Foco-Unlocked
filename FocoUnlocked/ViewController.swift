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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    // Elements that show up on the Upload page
    @IBOutlet var naviBar: UIView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemDesc: UITextView!
    @IBOutlet var itemTags: UITextField!
    
    @IBOutlet var uploadButton: UIButton!
    
    var photoImageView: UIImageView!
    
    var postsList: Array<Post> = [Post]()
    
    var imageData: NSData = NSData()
    
    let usersRef = FIRDatabase.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding attributes to the item's description box
        itemDesc!.layer.borderWidth = 1
        itemDesc!.layer.cornerRadius = 5
        itemDesc!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.photoImageView = UIImageView(frame: CGRectMake(10, 110, view.frame.size.width - 20, 220))
        self.photoImageView.backgroundColor = UIColor.lightGrayColor()
        //self.photoImageView.contentMode = .ScaleAspect
        self.view.addSubview(photoImageView)
        
        let horizontalConstraint = photoImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let verticalConstraint = photoImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let widthConstraint = photoImageView.widthAnchor.constraintEqualToAnchor(nil, constant: view.frame.size.width)
        let heightConstraint = photoImageView.heightAnchor.constraintEqualToAnchor(nil, constant: view.frame.size.width)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: itemName.frame.size.height - width, width: itemName.frame.size.width, height: itemName.frame.size.height)
        
        border.borderWidth = width
        itemName.layer.addSublayer(border)
        itemName.layer.masksToBounds = true   
        
    }
    
    // Function to open the Camera Button
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Function to open the Photo Library
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Function to choose an image from the Photo Library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
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
        
        var userPoints: Int = 0
        
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
                    let username = user!.displayName
                    var author: String = ""
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    if (username != nil) {
                        author = username!
                    } else if (username == nil) {
                        author = userEmail
                    }
                    let newPost: Post = Post(user: author, title: itemName.text!, description: itemDesc.text!, image: base64String, tagsString: itemTags.text!)
                    postsList.append(newPost)
                    Posts.child("posts").child(newPost.getIdString()).setValue(newPost.toArray())
                    
                    let alertController = UIAlertController(title: "Successful Upload", message:
                        "Your item is now on the public field!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    usersRef.child(userEmail).observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                        let postDict = snapshot.value as? [String : AnyObject]
                        if (postDict != nil) {
                            for object in postDict! {
                                let key = object.0
                                let obj = String(object.1)
                                if (key == "Points") {
                                    userPoints = Int(obj)!
                                    userPoints++
                                    print(userPoints)
                                } else if (key != "Points") {
                                }
                            }
                        }
                    })
                    self.usersRef.child("\(userEmail)").child("Points").setValue(String(userPoints))
                    
                }
                else if itemTags == nil {
                    let user = FIRAuth.auth()?.currentUser
                    let email: String! = user!.email
                    let userEmail = email.componentsSeparatedByString(".")[0]
                    let username = user!.displayName
                    var author: String = ""
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    if (username != nil) {
                        author = username!
                    } else if (username == nil) {
                        author = userEmail
                    }
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
        /*var title: Bool = false
        var desc: Bool = false
        let itemNameCheck: String = itemName.text!
        let itemDescCheck: String = itemDesc.text!
        
        if itemNameCheck.characters.count >= 1 {
        title = true
        }
        if itemDescCheck.characters.count >= itemNameCheck.characters.count {
        desc = true
        }
        
        
        if title == true || desc == true {
        let alertController = UIAlertController(title: "Discard Post", message:
        "Are your sure you want to give up on your creation?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        }*/
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
