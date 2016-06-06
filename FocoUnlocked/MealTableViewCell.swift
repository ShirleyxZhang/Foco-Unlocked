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

    // MARK: Properties
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bitesLabel: UILabel!
    @IBOutlet weak var bitesCounter: UILabel!
    @IBOutlet weak var upvoteControl: UpvoteControl!
    @IBOutlet weak var upvoteButton: UpvoteButton!
    
    var idString: String = ""
    
    let ref = FIRDatabase.database().reference().child("posts")
    
    var tapped = false


    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        upvoteButton.addGestureRecognizer(tap)
        upvoteButton.userInteractionEnabled = true
    }
    
    func configureCell(post: Post) {
        let post = post
        
        // Set the labels and textView.
        
        self.nameLabel.text = post.title
        self.bitesCounter.text = "Total Votes: \(post.bites)"
        //self.usernameLabel.text = joke.username
        
        // observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device.
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Set the thumb image.
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                
                // Current user hasn't voted for the joke... yet.
                
                print(thumbsUpDown)
                //upvoteButton.image = UIImage(named: "unfilled cookie.png")
            } else {
                
                // Current user voted for the joke!
                print("Yo")
                //upvoteButton.image = UIImage(named: "filled cookie.png")
            }
        })
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
                                click = false
                                print("Button filled")
                                self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
                                            var bitesNumberString = value
                                            var bitesNumber:Int = Int(bitesNumberString as! String)!
                                            bitesNumber = bitesNumber + 1
                                            self.ref.child(self.idString + "/Bites Number").setValue(String(bitesNumber) as! String)
                        } else if (!self.tapped && click == true) {
                            click = false
                            print("Button unfilled")
                            print(value)
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
        
        /*if (correctPost == true) {
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        if (self.tapped) {
            print("Button filled")
            self.upvoteButton.setBackgroundImage(UIImage(named: "filled cookie.png"), forState: UIControlState.Normal)
            let postDict = snapshot.value as? [String : AnyObject]
            for object in postDict! {
                let obj = object.1 as! NSDictionary
                for (key, value) in obj {
                    if (key as! String == "Bites Number") {
                        var bitesNumberString = value
                        var bitesNumber:Int = Int(bitesNumberString as! String)!
                        print("Number of bites: /(bitesNumber)")
                        bitesNumber = bitesNumber + 1
                        self.ref.child(self.idString + "/Bites Number").setValue(String(bitesNumber) as! String)
                    }
                }
            }
        } else if (!self.tapped) {
            print("Button unfilled")
            //print(value)
            self.upvoteButton.setBackgroundImage(UIImage(named: "unfilled cookie.png"), forState: UIControlState.Normal)
            let postDict = snapshot.value as? [String : AnyObject]
            for object in postDict! {
                let obj = object.1 as! NSDictionary
                for (key, value) in obj {
                    if (key as! String == "Bites Number") {
                        var bitesNumberString = value
                        var bitesNumber:Int = Int(bitesNumberString as! String)!
                        print("Number of bites: /(bitesNumber)")
                        bitesNumber = bitesNumber + 1
                        self.ref.child(self.idString + "/Bites Number").setValue(String(bitesNumber) as! String)
                    }
                }
            }
            }
            })
        }*/
    }
    
    
                // addSubtractVote(), in Joke.swift, handles the vote.
    
                //self.joke.addSubtractVote(true)
    
                // setValue saves the vote as true for the current user.
                // voteRef is a reference to the user's "votes" path.
    
                //self.voteRef.setValue(true)
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
        
    }
    

}
