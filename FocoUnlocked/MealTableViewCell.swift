//
//  MealTableViewCell.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/18/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import UIKit
import Firebase

class MealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bitesLabel: UILabel!
    @IBOutlet weak var bitesCounter: UILabel!
    @IBOutlet weak var upvoteControl: UpvoteControl!
    @IBOutlet weak var upvoteButton: UpvoteButton!
    
    var idString: String = ""
    
    let ref = FIRDatabase.database().reference().child("posts")
    let usersRef = FIRDatabase.database().reference().child("users")
    
    var tapped = false


    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        upvoteButton.addGestureRecognizer(tap)
        upvoteButton.userInteractionEnabled = true
    }
    
    func configureCell(meal: Meal) {
        let meal = meal
        
        // Set the labels and textView.
        
        nameLabel.text = meal.name
        photoImageView.image = meal.photo
        //cell.upvoteControl.upvote = meal.upvoted
        bitesCounter.text = meal.bites
        idString = meal.idString
        username.text = meal.user
        
        /*self.nameLabel.text = post.title
        self.bitesCounter.text = "\(post.bites)"*/
        //self.usernameLabel.text = joke.username
        
        // observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device.
        
        let user = FIRAuth.auth()?.currentUser
        let email: String! = user!.email
        let userEmail = email.componentsSeparatedByString(".")[0]
        
        /*ref.child("users/\(userEmail)").observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                print("FDSAF")
                if (!(snapshot.value is NSNull)) {
                    print("HERE")
                    let postDict = snapshot.value as? [String : AnyObject]
                    for object in postDict! {
                        print("SECOND")
                        let key = object.0 as! String
                        let obj = object.1 as! String
                        if (obj == "true" && key == self.idString) {
                            self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                        } else if (obj == "false" && key == self.idString) {
                            self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                        }
                    }
                } else {
                    self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                }
            })*/
        }
    
    func voteTapped(sender: UITapGestureRecognizer) {
        
        // observeSingleEventOfType listens for a tap by the current user.
        
        self.tapped = !self.tapped
        var correctPost = false
        var click = true
        
        
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
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
                            if (self.tapped && click == true) {
                                let user = FIRAuth.auth()?.currentUser
                                let email: String! = user!.email
                                let userEmail = email.componentsSeparatedByString(".")[0]
                                self.usersRef.child("\(userEmail)/\(self.idString)").setValue("true")
                                click = false
                                print("Button filled")
                                self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                                            var bitesNumberString = value
                                            var bitesNumber:Int = Int(bitesNumberString as! String)!
                                            bitesNumber = bitesNumber + 1
                                            self.ref.child(self.idString + "/Bites Number").setValue(String(bitesNumber) as! String)
                        } else if (!self.tapped && click == true) {
                                let user = FIRAuth.auth()?.currentUser
                                let email: String! = user!.email
                                let userEmail = email.componentsSeparatedByString(".")[0]
                                self.usersRef.child("\(userEmail)/\(self.idString)").setValue("false")
                            click = false
                            print("Button unfilled")
                            self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
                                var bitesNumberString = value
                                var bitesNumber:Int = Int(bitesNumberString as! String)!
                                bitesNumber = bitesNumber - 1
                                self.ref.child(self.idString + "/Bites Number").setValue(String(bitesNumber) as! String)
                }
                    }
                }
                }
            }
        })
           }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
        
    }
    

}
