//
//  MealTableViewController.swift
//  FocoUnlockedFeed
//
//  Created by Madison Minsk on 3/20/16.
//  Copyright © 2016 Madison Minsk. All rights reserved.
//

import UIKit
import Firebase

class MealTableViewController: UITableViewController {
    
    @IBOutlet weak var upvoteButton: UpvoteButton!
    
    // MARK: Properties
    
    var meals = [Meal]()
    var titles = [String]()
    var newImage: UIImageView = UIImageView()
    
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300.0
        tableView.scrollEnabled = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleMeals()
    }
    
    
    func loadSampleMeals() {
        var image: String = ""
        var title: String = ""
        var bites: String = ""
        var decodedImage = UIImage()
        let ref = FIRDatabase.database().reference().child("posts")
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            for object in postDict {// as! [ModelAttachment] {
                let obj = object.1 as! NSDictionary
                for (key, value) in obj {
                    if (key as! String == "Image") {
                        image = value as! String
                        let imageData = NSData(base64EncodedString: image as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            decodedImage = UIImage(data: imageData!)!
                    } else if (key as! String == "Title") {
                        title = value as! String
                    } else if (key as! String == "Bites Number") {
                        bites = value as! String
                    }
                    if (image != "" && title != "" && bites != "") {
                        let meal = Meal(name: title as String, photo: decodedImage, upvoted: true, bites: bites as String) as Meal!
                        self.meals as NSArray
                        self.meals.append(meal)
                        image = ""
                        title = ""
                        bites = ""

                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //************************************* Disables the delete option in list cells *******************/
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.editing {
            
            return UITableViewCellEditingStyle.Delete
            
        }
        
        return UITableViewCellEditingStyle.None
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 300.00
        //UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 300.0
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        //cell.upvoteControl.upvote = meal.upvoted
        cell.bitesCounter.text = meal.bites
        
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! MealTableViewCell
        
        let DestViewController = segue.destinationViewController as! DetailPostViewController
        
        let titleInfo: String = currentCell.nameLabel!.text!
        //let bitesInfo: String = currentCell.bitesCounter!.text!
        
        DestViewController.assignTitle(titleInfo)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
