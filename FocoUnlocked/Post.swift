    

import Foundation
import UIKit
import Firebase

class Post {
    var id: Int
    var idString: String
    var title: String
    var description: String
    var image: NSString
    var bites: Int
    var postDate: NSDate
    var tags: Array<String>
    
    struct idNumber {
        static var id = 0
    }
    
    init(title: String, description: String, image: NSString) {
        self.id = Post.idNumber.id++
        self.idString = NSUUID().UUIDString
        self.title = title
        self.description = description
        self.image = image
        self.bites = 0
        self.postDate = NSDate()
        self.tags = [String]()
    }
    
    init(title: String, description: String, image: NSString, tagsString: String) {
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
    
    func toArray() -> NSDictionary {
        let newArray = ["ID Number": "\(id)", "ID String": "\(idString)", "Title": "\(title)", "Description": "\(description)", "Image": "\(image)", "Bites Number": "\(bites)", "Post Date": "\(postDate)", "Tags": "\(tags)"]
        return newArray
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
    
    func addBite() {
        self.bites++
    }
    
    func subBite() {
        self.bites--
    }
}