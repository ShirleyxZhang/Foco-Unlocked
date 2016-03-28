//
//  ViewController.swift
//  Camera
//
//  Created by Sudikoff Lab iMac on 3/25/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var naviBar: UIView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemDesc: UITextView!
    @IBOutlet var itemTags: UITextField!
    
    @IBOutlet var uploadButton: UIButton!
    
    var photoImageView = UIImageView(frame: CGRectMake(20, 127, 380, 220))
    
    var postsList: Array<Post> = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.layer.cornerRadius = 3
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
    
    @IBAction func uploadButton(sender: AnyObject) {
        
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
                    let newPost: Post = Post(title: itemName.text!, description: itemDesc.text!, image: photoImageView.image!, tagsString: itemTags.text!)
                    postsList.append(newPost)
                }
                else if itemTags == nil {
                    let newPost: Post = Post(title: itemName.text!, description: itemDesc.text!, image: photoImageView.image!)
                    postsList.append(newPost)
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


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

