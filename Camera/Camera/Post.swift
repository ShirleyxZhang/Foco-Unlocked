//
//  Post.swift
//  Camera
//
//  Created by Sudikoff Lab iMac on 3/26/16.
//  Copyright © 2016 Sudikoff Lab iMac. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var id: Int
    var title: String
    var description: String
    var image: UIImage
    var bites: Int
    var postDate: NSDate
    var tags: Array<String>
    
    struct idNumber {
        static var id = 0
    }
    
    init(title: String, description: String, image: UIImage) {
        self.id = Post.idNumber.id++
        self.title = title
        self.description = description
        self.image = image
        self.bites = 0
        self.postDate = NSDate()
        self.tags = [String]()
    }
    
    init(title: String, description: String, image: UIImage, tagsString: String) {
        self.id = Post.idNumber.id++
        self.title = title
        self.description = description
        self.image = image
        self.bites = 0
        self.postDate = NSDate()
        self.tags = tagsString.componentsSeparatedByString(", ")
        if tagsString != "" {
            if tags[tags.count - 1] == "" {
                tags.removeLast()
            }
            if String(tags[tags.count - 1].characters.last!) == "," || String(tags[tags.count - 1].characters.last!) == " " {
                let tempString: String = tags[tags.count - 1]
                tags[tags.count - 1] = tempString.substringToIndex(tempString.endIndex.predecessor())
            }
        }
    }

    
    func addTag(tag: String) {
        tags.append(tag)
    }
    
    func getTags() -> String {
        var returnString: String = ""
        for var i = 0; i > tags.count; i++ {
            returnString = returnString + "#" + tags[i] + " "
        }
        return returnString
    }

    func getPostDate() -> NSDate {
        return self.postDate
    }
    
    func getBites() -> Int {
        return self.bites
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func addBite() {
        self.bites++
    }
    
    func subBite() {
        self.bites--
    }
}