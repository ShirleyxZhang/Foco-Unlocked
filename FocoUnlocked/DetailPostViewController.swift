//
//  DetailPostViewController.swift
//  FocoUnlocked
//
//  Grabs information from the database and populates the page with correct information
//
//  Created by WISP on 3/25/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Firebase

class DetailPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    // Elements that show up on the Upload page
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTags: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    var newTitle: String = " "
    var newDescription: String = " "
    var newImage: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newTitle
        
        if (self.revealViewController() != nil) {
        settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        postTitle.text = newTitle
        postDescription.text = newDescription
        let ref = FIRDatabase.database().reference()
        ref.child("posts").queryOrderedByChild("Title")
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if (snapshot.value!.objectForKey("Title") as! String == self.newTitle) {
                let base64EncodedString = snapshot.value!.objectForKey("Image")
                let imageData = NSData(base64EncodedString: base64EncodedString as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                if (imageData != nil) {
                let decodedImage = UIImage(data: imageData!)
                self.postImage.image = decodedImage;
                    
                /********* WILL LATER PRINT OUT BITES NUM AND USERNAME **********/
                     
                //var bitesNum = (snapshot.value.objectForKey("Bites Number") as! NSString)
                //var username = (snapshot.value.objectForKey("") as! NSString)
                var tags = snapshot.value!.objectForKey("Tags") as! NSString
                    if (tags == "" || tags.length == 0) {
                        tags = "No tags"
                    }
                var tempString: String = "";
                    self.postTags.text = tags as String;
                    for i in self.postTags.text!.characters {
                        if (i != "]" && i != "[" && i != "\"") {
                            tempString = tempString + String(i);
                        }
                    }
                    self.postTags.text = tempString;
                    print(self.postTags.text!);
                    tempString = "";
                    let description = snapshot.value!.objectForKey("Description") as! NSString;
                    if (self.postDescription.text.characters.count <= 0) {
                        self.postDescription.text = "No Description"
                    } else if (self.postDescription.text.characters.count > 0) {
                        self.postDescription.text = description as String;
                    }
                }
                }
            })
    }
    
    // Pops the program to previous page
    @IBAction func backButton(sender: AnyObject) {
        print("Step back")
        
        /********* THIS MIGHT CAUSE ERRORS ***********/
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Helper function to get the title to print out
    func assignTitle(title: String) {
        newTitle = title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


