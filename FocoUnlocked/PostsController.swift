//
//  ViewController.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/8/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class PostsController: UIViewController {
    
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a reference to a Firebase location
        //var myRootRef = Firebase(url:"https://sweltering-torch-5367.firebaseio.com")
        
        // Write data to Firebase
        //myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        // Read data and react to changes
        //myRootRef.observeEventType(.Value, withBlock: {
        //snapshot in
        //print("\(snapshot.key) -> \(snapshot.value)")
        //})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}



