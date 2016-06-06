//
//  CreateAccountViewController.swift
//  FocoUnlockedLogin
//
//  Created by Sudikoff Lab iMac on 3/17/16.
//  Copyright © 2016 wisp. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    // Variables for the text fields show in the app
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAccount(sender: AnyObject) {
        
        // Holds the text of the email and password text fields
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        let ref = FIRDatabase.database().reference()
        
        if email != "" && password != ""
        {
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                
                if error == nil
                {
                            NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            print("Account Created :)")
                            self.performSegueWithIdentifier("fromSignupToFeed", sender: self)
                    // Otherwise an error will be printed to the terminal
                }
                    else {
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
    
    @IBAction func cancel(sender: AnyObject) {
        // self.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }
}
