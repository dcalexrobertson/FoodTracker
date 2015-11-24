//
//  ProfileViewController.swift
//  FoodTracker
//
//  Created by Alex on 2015-11-23.
//  Copyright © 2015 Alex. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    var user = PFUser.currentUser()!
    var meals = [Meal]()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    @IBOutlet weak var mealTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayUserInfo()
        fetchUserMeals()

    }
    
    func displayUserInfo() {
        
        usernameLabel.text = user.username
        userTypeLabel.text = user.objectForKey("userType") as? String
        
        let profileImage = user.objectForKey("profileImage") as? PFFile
        profileImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.profileImageView.image = UIImage(data: data!)
            })
        })
    }

    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        
        meal.photo?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
        })
        
        cell.ratingControl.rating = meal.rating
        
        return cell
    }


    // MARK: Fetch User's Meals From Parse
    
    func fetchUserMeals() {
            
            let query = PFQuery(className:"Meal")
            query.whereKey("user", equalTo: user)
            query.findObjectsInBackgroundWithBlock {
                (comments: [PFObject]?, error: NSError?) -> Void in
                
                if let meals = comments as? [Meal] {
                    
                    self.meals = meals
                }
                
                self.mealTableView.reloadData()
            }

        }

}
    
