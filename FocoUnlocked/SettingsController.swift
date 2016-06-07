//
//  SettingsController.swift
//  FocoUnlocked
//
//  View controller for the settings page
//  This will be changed to hold more options
//  Later, users should have the ability to swipe from the right to open the settings page
//
//  Created by WISP on 4/11/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var focoFreq: UITextView!
    @IBOutlet weak var usingApp: UITextView!
    @IBOutlet weak var suggestions: UITextView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        suggestions!.layer.borderWidth = 1
        suggestions!.layer.cornerRadius = 5
        suggestions!.layer.borderColor = UIColor.grayColor().CGColor
        
        focoFreq!.layer.borderWidth = 1
        focoFreq!.layer.cornerRadius = 5
        focoFreq!.layer.borderColor = UIColor.grayColor().CGColor
        
        usingApp!.layer.borderWidth = 1
        usingApp!.layer.cornerRadius = 5
        usingApp!.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("logout", sender: self)
        print("Logged out :)")
    }
    
    
    @IBAction func sendSuggestion(sender: AnyObject) {
        let ref = FIRDatabase.database().reference().child("suggestions")
        
        var sugg: Bool = true;
        let suggestionsCheck: String = suggestions.text!
        let focoFreqCheck: String = focoFreq.text!
        let usingAppCheck: String = usingApp.text!
        
        if (suggestionsCheck.characters.count <= 0 && focoFreqCheck.characters.count <= 0 && usingAppCheck.characters.count <= 0) {
            sugg = false;
        }
        
        if (sugg == true) {
            let newSuggestions = ["How often goes to Foco": focoFreqCheck, "How to use the app": usingAppCheck, "post": suggestionsCheck]
            let idString = NSUUID().UUIDString
            ref.child(idString).setValue(newSuggestions)
            //Suggestion.setValue(newSuggestions)
            let alertController = UIAlertController(title: "Successful Suggestion", message:
                "Thank you for your feedback!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: { action in
                return
            }))
        } else {
            let alertController = UIAlertController(title: "Suggestions Error", message:
                "Your suggestion isn't detailed enough", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.Default,handler: nil))
        }
        

    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}