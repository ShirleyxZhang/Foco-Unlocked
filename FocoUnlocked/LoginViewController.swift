//
//  LoginViewController.swift
//  FocoUnlocked
//
//  The view controller for defining the Login Page
//
//  Created by WISP on 3/16/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var loginView: UIView!
    // All the variables that will be shown within the app
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")*/
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 50
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 50
            }
            else {
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Logins in the user
    @IBAction func loginAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            // Attemps to log into an existing account
            FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
                
                // Handels the case of an error
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    print("Logged in :)")
                    self.performSegueWithIdentifier("fromLoginToFeed", sender: self)
                }
                else if (error!.code == 17020) // An error message for no internet connection
                {
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Log in Error", message: "No Internet Connection", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17010) { // An error message for too many requests
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Too Many Requests", message: "Too Many System Requests. Please try again later", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17009) {  // An error message for the incorrect password
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Incorrect Password", message: "Please enter the correct password", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17011) {  // An error message for the incorrect email
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Incorrect Email", message: "Please enter the correct email", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {   // An error message for any other error
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "System Error", message: "Error in the System. Please try again later", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        else // If nothing was input to the text fields, an error message will be returned to the users
        {
            let alert = UIAlertController(title: "Log in Error", message: "Enter Email and Password", preferredStyle:.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }
    
    // Logs the user out
    @IBAction func logoutAction(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
    }
}
