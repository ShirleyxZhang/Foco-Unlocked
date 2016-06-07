//
//  BaseService.swift
//  FocoUnlocked
//
//  Defines the global references for the entire program
//
//  Created by WISP on 3/16/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Firebase

let FIREBASE_REF = FIRDatabase.database().reference()

var CURRENT_USER: FIRDatabaseReference
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = FIRDatabase.database().reference().child("users").child(userID)
    
    return currentUser
}