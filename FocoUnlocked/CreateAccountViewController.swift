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
    
    let usersRef = FIRDatabase.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAccountViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAccountViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 60
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 60
            }
            else {
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func createAccount(sender: AnyObject) {
        
        // Holds the text of the email and password text fields
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let username = self.usernameTextField.text
        
        let userEmail = email!.componentsSeparatedByString(".")[0]
        
        self.usersRef.child("\(userEmail)").child("Username").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (!(snapshot.value is NSNull)) {
                var pointsNumberString = Int(snapshot.value! as! String)
                if (pointsNumberString > 0) {
                    pointsNumberString = pointsNumberString! - 1
                }
                self.usersRef.child("users").child("\(userEmail)").child("Username").setValue(username!)
            } else {
                self.usersRef.child("users").child("\(userEmail)").child("Username").setValue(username!)
            }
        })
        
        if email != "" && password != "" && username != ""
        {
            // Attempts to create a new user
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("Account Created :)")
                    let user = FIRAuth.auth()?.currentUser
                    let email: String! = user!.email
                    let userEmail = email.componentsSeparatedByString(".")[0]
                    
                    // Sets the user's points to 0 when they first create an account
                    
                    self.usersRef.child("\(userEmail)/Points").setValue("0")
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
