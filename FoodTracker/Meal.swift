//
//  Meal.swift
//  FoodTracker
//
//  Created by Alex on 2015-11-22.
//  Copyright © 2015 Alex. All rights reserved.
//


import UIKit
import Parse
import ObjectiveC

class Meal: PFObject, PFSubclassing {
    
    // MARK: Properties
    
    @NSManaged var name: String?
    @NSManaged var photo: PFFile?
    @NSManaged var rating: Int
    @NSManaged var user: PFUser?
    
    
    //MARK: Class Methods
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Meal"
    }
    
    // MARK: Initialization
    

    override init() {
        super.init()
    }
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties.
        super.init()
        
        self.name = name
        
        if let data = UIImageJPEGRepresentation(photo!, 0.5) {
            self.photo = PFFile(data: data)
        }
        
        self.rating = rating
        
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
//    // MARK: Archiving Paths
//    
//    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
//    
//    // MARK: Types
//    
//    struct PropertyKey {
//        
//        static let nameKey = "name"
//        static let photoKey = "photo"
//        static let ratingKey = "rating"
//    }
//    
//    
//    // MARK: NSCoding
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        
//        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
//        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
//        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        
//        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
//        // Because photo is an optional property of Meal, use conditional cast.
//        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
//        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
//        
//        // Must call designated initilizer.
//        self.init(name: name, photo: photo, rating: rating)
//
//    }
}
