//
//  MealTableViewCell.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/18/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    // MARK: Properties
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bitesLabel: UILabel!
    @IBOutlet weak var bitesCounter: UILabel!
    @IBOutlet weak var upvoteControl: UpvoteControl!
    
    //@IBOutlet weak var nameLabel: UILabel!
    
    //@IBOutlet weak var photoImageView: UIImageView!

    //@IBOutlet weak var upvoteControl: UpvoteControl!
    
    //@IBOutlet weak var bitesLabel: UILabel!
    
    //@IBOutlet weak var bitesCounter: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
        
    }
    

}
