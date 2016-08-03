//
//  NavigationController.swift
//  FocoUnlocked
//
//  Created by Sudikoff Lab iMac on 8/2/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "namefinal.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
}
