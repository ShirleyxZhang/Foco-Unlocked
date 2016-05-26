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
                    /*FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in*/
                        
                        // If there is no error, a positive message will be sent to the terminal and the user will have a new account
                        
                        //if error == nil
                        //{
                            NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                            //ref.child("users").child(user!.uid).setValue(["username": email!, "password": password!])
                            NSUserDefaults.standardUserDefaults().synchronize()
                            print("Account Created :)")
                            self.performSegueWithIdentifier("fromSignupToFeed", sender: self)
                            //self.dismissViewControllerAnimated(true,    completion: nil)
                        //}
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
                //else // Otherwise an error will be printed to the terminal
                //{
                  //  print(error)
                //}
                
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
