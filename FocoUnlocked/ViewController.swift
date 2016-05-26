//
//  ViewController.swift
//  Camera
//
//  Created by Sudikoff Lab iMac on 3/25/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var naviBar: UIView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemDesc: UITextView!
    @IBOutlet var itemTags: UITextField!
    
    @IBOutlet var uploadButton: UIButton!
    
    var photoImageView = UIImageView(frame: CGRectMake(20, 127, 380, 220))
    
    var postsList: Array<Post> = [Post]()
    
    var imageData: NSData = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //uploadButton.layer.cornerRadius = 3
        
        itemDesc!.layer.borderWidth = 1
        itemDesc!.layer.cornerRadius = 5
        itemDesc!.layer.borderColor = UIColor.grayColor().CGColor
        
        self.photoImageView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(photoImageView)

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: itemName.frame.size.height - width, width: itemName.frame.size.width, height: itemName.frame.size.height)
        
        border.borderWidth = width
        itemName.layer.addSublayer(border)
        itemName.layer.masksToBounds = true
        

    }
    
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    //keyboard goes away after you tap somewhere else
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func uploadButton(sender: AnyObject) {
        
        let myRootRef = FIRDatabase.database().reference() //Firebase(url: "https://focounlocked.firebaseio.com/")
        let Posts = myRootRef.child("posts")
        
        var title: Bool = false
        var desc: Bool = false
        let itemNameCheck: String = itemName.text!
        let itemDescCheck: String = itemDesc.text!
        
        if itemNameCheck.characters.count >= 4 {
            title = true
        }
        if itemDescCheck.characters.count >= itemNameCheck.characters.count {
            desc = true
        }
        
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
        else {
            if photoImageView.image != nil {
                
                if itemTags != nil {
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    let newPost: Post = Post(title: itemName.text!, description: itemDesc.text!, image: base64String, tagsString: itemTags.text!)
                    postsList.append(newPost)
                    Posts.child(newPost.getIdString()).setValue(newPost.toArray())
                    
                    let alertController = UIAlertController(title: "Successful Upload", message:
                        "Your item is now on the public field!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    
                    
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                    }
                else if itemTags == nil {
                    self.imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.1)!
                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    let newPost: Post = Post(title: itemName.text!, description: itemDesc.text!, image: base64String)
                    postsList.append(newPost)
                    Posts.child(newPost.getIdString()).setValue(newPost.toArray())
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
    
    @IBAction func cancelButton(sender: AnyObject) {
        var title: Bool = false
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
            
        }

        
        navigationController?.popViewControllerAnimated(true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

