//
//  Meal.swift
//  FocoUnlockedFeed
//
//  Object that holds the information for each meal
//  A meal is pulled from the database
//  Object will be inserted into a long list that will print out to the feed
//
//  Created by WISP on 3/20/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class Meal: NSObject {
    
    // The attributes of the meal
    var user: String
    var name: String
    var photo: UIImage?
    var upvoted: Bool
    var bites: String
    var idString: String

    // Initializer function
    init?(user: String, name: String, photo: UIImage?, upvoted: Bool, bites: String, id: String) {
        
        // Initialize stored properties.
        self.user = user
        self.name = name
        self.photo = photo
        self.upvoted = upvoted
        self.bites = bites
        self.idString = id
    }
    
}
