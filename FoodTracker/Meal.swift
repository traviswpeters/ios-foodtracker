//
//  Meal.swift
//  FoodTracker
//

import UIKit

class Meal: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: Archiving Paths
    
    // You mark these constants with the static keyword, which means they apply to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")

    // MARK: Types
    
    // The static keyword indicates that this constant applies to the structure itself, not an instance of the structure. These values will never change.
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    // Prepares the class’s information to be archived.
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    // The initializer unarchives the data when the class is created.
    required convenience init?(coder aDecoder: NSCoder) {
        // Because name is a required property of Meal, use forced cast.
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        // No need to cast since rating was encoded as an Integer.
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }

}