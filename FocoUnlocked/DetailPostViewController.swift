//
//  ViewController.swift
//  Camera
//
//  Created by Sudikoff Lab iMac on 3/25/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import UIKit
import Firebase

class DetailPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTags: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    var newTitle: String = " "
    var newDescription: String = " "
    var newImage: UIImageView = UIImageView()
    
    var PostsArray = [PostList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTitle.text = newTitle
        postDescription.text = newDescription
        let ref = FIRDatabase.database().reference().child("posts")//Firebase(url:"https://focounlocked.firebaseio.com/posts")
        ref.queryOrderedByChild("Title")
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if (snapshot.value!.objectForKey("Title") as! String == self.newTitle) {
                let base64EncodedString = snapshot.value!.objectForKey("Image")
                let imageData = NSData(base64EncodedString: base64EncodedString as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                if (imageData != nil) {
                let decodedImage = UIImage(data: imageData!)
                self.postImage.image = decodedImage;
                //var bitesNum = (snapshot.value.objectForKey("Bites Number") as! NSString)
                let tags = snapshot.value!.objectForKey("Tags") as! NSString
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
    
    @IBAction func backButton(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func assignTitle(title: String) {
        newTitle = title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


