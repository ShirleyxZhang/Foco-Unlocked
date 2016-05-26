//
//  DataService.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/18/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    let BASE_URL = "https://focounlocked.firebaseio.com"
    
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _USER_REF = FIRDatabase.database().reference()
    private var _IMAGE_REF = FIRDatabase.database().reference().child("images") //Firebase(url: "https:focounlocked.firebaseio.com/images")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = FIRDatabase.database().reference().child("users").child(userID)//Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser
    }
    
    var IMAGE_REF: FIRDatabaseReference {
        return _IMAGE_REF
    }
}
