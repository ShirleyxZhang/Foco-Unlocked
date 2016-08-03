//
//  FeedController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 6/14/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class FeedController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var feedContainer: UIView!
    
    var leftViewController: UIViewController? {
        willSet{
            if self.leftViewController != nil {
                if self.leftViewController!.view != nil {
                    self.leftViewController!.view!.removeFromSuperview()
                }
                self.leftViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.leftViewController!.view)
            self.addChildViewController(self.leftViewController!)
        }
    }
    
    var rightViewController: UIViewController? {
        willSet {
            if self.rightViewController != nil {
                if self.rightViewController!.view != nil {
                    self.rightViewController!.view!.removeFromSuperview()
                }
                self.rightViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.rightViewController!.view)
            self.addChildViewController(self.rightViewController!)
        }
    }
    
    var menuShown: Bool = false
    
    /*@IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        showMenu()
        
    }
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        hideMenu()
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(FeedController.showMenu(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(FeedController.hideMenu(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 1, green: 128/255, blue: 0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as! [String : AnyObject]
        
    }
    
    func showMenu(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuViewController: SettingsController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController")as! SettingsController
        
        self.rightViewController = menuViewController
        
        self.rightViewController!.view.frame.origin.x = self.rightViewController!.view.frame.origin.x - 400
        UIView.animateWithDuration(0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: self.view.frame.origin.x - 100, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = true
                self.feedContainer.userInteractionEnabled = false
        })
    }
    
    func hideMenu(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: -600, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = false
                self.feedContainer.userInteractionEnabled = true
        })
    }
    
    var showMenuCheck: Bool = false
    
    @IBAction func toggleSettings(sender: AnyObject) {
        if showMenuCheck == false {
            showMenu(self)
            showMenuCheck = true
        } else if showMenuCheck == true {
            hideMenu(self)
            showMenuCheck = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}