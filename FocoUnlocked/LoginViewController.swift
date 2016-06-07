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
    
    // All the variables that will be shown within the app
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                } else {  // An error message for any other error
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
