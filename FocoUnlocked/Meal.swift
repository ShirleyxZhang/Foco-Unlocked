//
//  Meal.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/20/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import UIKit

class Meal: NSObject {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var upvoted: Bool
    var bites: String
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, upvoted: Bool, bites: String) {
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.upvoted = upvoted
        self.bites = bites
        
        // Initialization should fail if there is no name or if the rating is negative.
        //if name.isEmpty {
            //return nil
        //}
    }
    
}
