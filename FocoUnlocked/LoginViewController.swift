//
//  LoginViewController.swift
//  FocoUnlockedLogin
//
//  Created by Sudikoff Lab iMac on 3/16/16.
//  Copyright © 2016 wisp. All rights reserved.
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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        //{
            self.logoutButton.hidden = false
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Logins in the user
    
    @IBAction func loginAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            // Checks to see if account exists
            
            FIRAuth.auth()!.signInAnonymouslyWithCompletion() { (user, error) in
            
                // If there is no error then a positive message will be sent to the terminal and not hide the logout button
                
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    print("Logged in :)")
                    self.performSegueWithIdentifier("fromLoginToFeed", sender: self)
                    //self.logoutButton.hidden = false
                }
                else // Otherwise, an error message will be printed to the terminal
                {
                    print(error)
                }
            }
        }
        
        else // If nothing was input to the text fields, an error message will be returned to the users
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password", preferredStyle:.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        //CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
    }
}
