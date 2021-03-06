//
//  SuggestionsController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 6/8/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SuggestionsController: UIViewController {

@IBOutlet weak var settingsButton: UIButton!
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
        
        if (self.revealViewController() != nil) {
            settingsButton.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}