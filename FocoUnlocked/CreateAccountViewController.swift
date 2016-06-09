//
//  CreateAccountViewController.swift
//  FocoUnlockedLogin
//
//  The view controller to create a new account
//
//  Created by WISP on 3/17/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    
    // Variables for the text fields show in the app
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func createAccount(sender: AnyObject) {
        
        // Holds the text of the email and password text fields
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let username = self.usernameTextField.text
        
        if email != "" && password != "" && username != ""
        {
            // Attempts to create a new user
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("Account Created :)")
                    self.performSegueWithIdentifier("fromSignupToFeed", sender: self)
                } // HANDLE THE ERROR WHEN A NEW USER TRIES TO USE THE SAME EMAIL ADDRESS
                else if (error!.code == 17007) {
                    let alert = UIAlertController(title: "Error", message: "Email already in use", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("print error: \(error) \n")
                }  else {
                    let alert = UIAlertController(title: "Error", message: "Incorret Information.", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("print error: \(error) \n")
                }
            }
        }
        else // If nothing is entered in the email or password fields, an error will be returned to the user
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }

            
            
    }
    
    // Pops the user back to the previous page
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
