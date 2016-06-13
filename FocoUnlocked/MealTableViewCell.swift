//
//  MealTableViewCell.swift
//  FocoUnlockedFeed
//
//  The table view cell that will hold each post
//
//  Created by WISP on 3/18/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Firebase

class MealTableViewCell: UITableViewCell {
    
    // Elements that show up on the Upload page
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bitesLabel: UILabel!
    @IBOutlet weak var bitesCounter: UILabel!
    @IBOutlet weak var upvoteControl: UpvoteControl!
    @IBOutlet weak var upvoteButton: UpvoteButton!
    
    var idString: String = ""
    var configured: Bool = false
    
    let ref = FIRDatabase.database().reference()
    let usersRef = FIRDatabase.database().reference()
    
    var tapped = false
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Calls listener functions that will handle the user's actions
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        upvoteButton.addGestureRecognizer(tap)
        upvoteButton.userInteractionEnabled = true
    }
    
    // Configures the cell upon initial creation
    func configureCell(meal: Meal) {
        let meal = meal
        
        // Set the labels and textView
        
        nameLabel.text = meal.name
        photoImageView.image = meal.photo
        //cell.upvoteControl.upvote = meal.upvoted
        bitesCounter.text = meal.bites
        idString = meal.idString
        username.text = meal.user
        
        /*self.nameLabel.text = post.title
        self.bitesCounter.text = "\(post.bites)"*/
        //self.usernameLabel.text = joke.username
        
        /*********** MAKE SURE TO CHANGE WHEN USERNAMES ARE USED INSTEAD OF EMAILS **********/
        
        let user = FIRAuth.auth()?.currentUser
        let email: String! = user!.email
        let userEmail = email.componentsSeparatedByString(".")[0]
        usersRef.child("users").child(userEmail).observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let postDict = snapshot.value as? [String : AnyObject]
            if (postDict != nil) {
                for object in postDict! {
                    let key = object.0
                    let obj = String(object.1)
                    if (obj == "true" && key == self.idString) {
                        self.ref.child("posts").child("\(self.idString)").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                            if (!(snapshot.value!.objectForKey("Bites Number") is NSNull)) {
                                if (Int(snapshot.value!.objectForKey("Bites Number") as! String)! == 0) {
                                    self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                                } else if (Int(snapshot.value!.objectForKey("Bites Number") as! String)! > 0) {
                                    self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                                }
                            }
                        })
                    } else if ((obj == "false" && key == self.idString) || (postDict == nil && key == self.idString)) {
                        self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                    }
                }
            } else {
                print("postDict: \(postDict)")
                self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
            }
            
        })
        
    }
    
    // Function that will be called when the user clicks the like button
    func voteTapped(sender: UITapGestureRecognizer) {
        
        // observeSingleEventOfType listens for a tap by the current user.
        
        self.tapped = !self.tapped
        var correctPost = false
        var click = true
        
        // Loops through all the cells to add the right attributes
        ref.child("posts").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                let postDict = snapshot.value as? [String : AnyObject]
                for object in postDict! {
                    let obj = object.1 as! NSDictionary
                    for (key, value) in obj {
                        if (key as! String == "ID String") {
                            if (value as! String == self.idString) {
                                correctPost = true
                            } else {
                                correctPost = false
                            }
                        } else if (key as! String == "Bites Number" && correctPost == true) {
                            let user = FIRAuth.auth()?.currentUser
                            let email: String! = user!.email
                            let userEmail = email.componentsSeparatedByString(".")[0]
                            self.usersRef.child("users").child("\(userEmail)").child("\(self.idString)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                if (!(snapshot.value is NSNull)) {
                                    if ((snapshot.value! as! String == "false" && click == true) || (snapshot.value == nil && click == true)) {
                                        self.usersRef.child("users").child("\(userEmail)/\(self.idString)").setValue("true")
                                        click = false
                                        print("Button filled")
                                        self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                                        let bitesNumberString = value
                                        var bitesNumber:Int = Int(bitesNumberString as! String)!
                                        bitesNumber = bitesNumber + 1
                                        self.usersRef.child("users").child("\(userEmail)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                            if (!(snapshot.value is NSNull)) {
                                                var pointsNumberString = Int(snapshot.value! as! String)
                                                pointsNumberString = pointsNumberString! + 1
                                                self.usersRef.child("users").child("\(userEmail)").child("Points").setValue(String(pointsNumberString!))
                                            }
                                        })
                                        self.ref.child("posts").child(self.idString + "/Bites Number").setValue(String(bitesNumber))
                                    } else if (snapshot.value! as! String == "true" && click == true) {
                                        self.usersRef.child("users").child("\(userEmail)/\(self.idString)").setValue("false")
                                        click = false
                                        print("Button unfilled")
                                        self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                                        let bitesNumberString = value
                                        var bitesNumber:Int = Int(bitesNumberString as! String)!
                                        bitesNumber = bitesNumber - 1
                                        self.usersRef.child("users").child("\(userEmail)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                            if (!(snapshot.value is NSNull)) {
                                                var pointsNumberString = Int(snapshot.value! as! String)
                                                if (pointsNumberString > 0) {
                                                    pointsNumberString = pointsNumberString! - 1
                                                }
                                                self.usersRef.child("users").child("\(userEmail)").child("Points").setValue(String(pointsNumberString!))
                                            }
                                        })
                                        self.ref.child("posts").child(self.idString + "/Bites Number").setValue(String(bitesNumber))
                                    }
                                } else {
                                    self.usersRef.child("users").child("\(userEmail)/\(self.idString)").setValue("true")
                                    self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                                    click = false
                                    print("Button filled")
                                    let bitesNumberString = value
                                    var bitesNumber:Int = Int(bitesNumberString as! String)!
                                    bitesNumber = bitesNumber + 1
                                    self.usersRef.child("users").child("\(userEmail)").child("Points").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                        if (!(snapshot.value is NSNull)) {
                                            var pointsNumberString = Int(snapshot.value! as! String)
                                            pointsNumberString = pointsNumberString! + 1
                                            self.usersRef.child("users").child("\(userEmail)").child("Points").setValue(String(pointsNumberString!))
                                        }
                                    })
                                    self.ref.child("posts").child(self.idString + "/Bites Number").setValue(String(bitesNumber))
                                }
                                
                            })
                        }
                    }
                }
            }
        })
    }
    
    // Function that handles each cell upon selection
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}