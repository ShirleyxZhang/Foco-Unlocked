//
//  Post.swift
//  FocoUnlocked
//
//  Holds all the information for each
//  A post will be sent to the database
//
//  Created by WISP on 6/7/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    // The attributes of the meal
    var user: String
    var id: Int
    var idString: String
    var title: String
    var description: String
    var image: NSString
    var bites: Int
    var postDate: NSDate
    var tags: Array<String>
    
    // Struct to hold each post's idNumber
    struct idNumber {
        static var id = 0
    }
    
    // Initializer function that doesn't take in tags
    init(user: String, title: String, description: String, image: NSString) {
        self.user = user
        self.id = Post.idNumber.id++
        self.idString = NSUUID().UUIDString
        self.title = title
        self.description = description
        self.image = image
        self.bites = 0
        self.postDate = NSDate()
        self.tags = [String]()
    }
    
    // Initializer function that does take in tags
    init(user: String, title: String, description: String, image: NSString, tagsString: String) {
        self.user = user
        self.id = Post.idNumber.id++
        self.idString = NSUUID().UUIDString
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
    
    // Function that prints out all the contents of each post
    func toArray() -> NSDictionary {
        let newArray = ["ID Number": "\(id)", "ID String": "\(idString)", "Author": "\(user)", "Title": "\(title)", "Description": "\(description)", "Image": "\(image)", "Bites Number": "\(bites)", "Post Date": "\(postDate)", "Tags": "\(tags)"]
        return newArray
    }
    
    
    /******** The following functions are accessor functions for each attribute ********/
    
    func getUser() -> String {
        return user
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
    
    func getIdString() -> String {
        return self.idString
    }
    
    // Adds a bite to the current post
    func addBite() {
        self.bites = self.bites + 1
    }
    
    // Subtracts a bite from the current post
    func subBite() {
        self.bites = self.bites - 1
    }
}