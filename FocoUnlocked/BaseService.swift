//
//  BaseService.swift
//  FocoUnlockedLogin
//
//  Created by Sudikoff Lab iMac on 3/16/16.
//  Copyright © 2016 wisp. All rights reserved.
//

import Foundation
import Firebase

//let BASE_URL = "https://focounlocked.firebaseio.com/"

let FIREBASE_REF = FIRDatabase.database().reference()//Firebase(url: BASE_URL)

var CURRENT_USER: FIRDatabaseReference
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = FIRDatabase.database().reference().childByAppendingPath("users").childByAppendingPath(userID)
    //Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    
    return currentUser
}