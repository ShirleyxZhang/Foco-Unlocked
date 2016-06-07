//
//  UpvoteButton.swift
//  FocoUnlocked
//
//  Implmentation of the upvote (bite) button
//  MIGHT NEED TO DELETE THIS FILE
//
//  Created by WISP on 4/27/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class UpvoteButton: UIButton {
    
    var upvoted = false;
    let unfilledCookie = UIImage(named: "unfilled cookie.png")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setBackgroundImage(unfilledCookie, forState: .Normal)
        
        self.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    }
    
    func buttonPressed(sender: UIButton!) -> Int {
        
        upvoted = !upvoted
        if (upvoted == true) {
            print("Button Selected\n")
        } else if (upvoted == false) {
            print("Button Deselected\n")
            
        }
        
        guard let filledCookie = UIImage(named: "filled cookie.png") else {
            
            print("Image Not Found")
            // The image was not found
            return 2
            
        }
        
        if upvoted {
            sender.setBackgroundImage(filledCookie, forState: UIControlState.Normal)
            // The cookie icon was colored and selected
            return 0
        } else {
            sender.setBackgroundImage(unfilledCookie, forState: UIControlState.Normal)
            // The cookie icon was uncolored and deselected
            return 1
        }
        
    }
}

