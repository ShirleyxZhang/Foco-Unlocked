//
//  UpvoteControl.swift
//  FocoUnlocked
//
//  Control file that will handle the actions of the bite button
//
//  Created by WISP on 3/18/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class UpvoteControl: UIView {
    
    var upvote = false
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let filledCookieImage = UIImage(named: "filledCookie")
        let emptyCookieImage = UIImage(named: "emptyCookie")
        
        let button = UIButton()
        
        button.setImage(emptyCookieImage, forState: .Normal)
        button.setImage(filledCookieImage, forState: .Selected)
        button.setImage(filledCookieImage, forState: [.Highlighted, .Selected])
        
        button.adjustsImageWhenHighlighted = false
        
        button.addTarget(self, action: "upvoteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

        
        addSubview(button)
    }
    
    
    override func intrinsicContentSize() -> CGSize {
        
        let buttonSize = Int(frame.size.height)
        let width = buttonSize
        
        return CGSize(width: width, height: buttonSize)
    }
    
    
}










