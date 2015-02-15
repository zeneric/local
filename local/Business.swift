//
//  Business.swift
//  local
//
//  Created by Eric Huang on 2/15/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class Business: NSObject {
    var imageURL: String?
    var name: String?
    var ratingImageURL: String?
    var numReviews: Int?
    var address: String?
    var categories: NSArray?
//    var distance: CGFloat
    
    init (dictionary: NSDictionary) {
        // Name
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        // Image URL
        if let imageURL = dictionary["image_url"] as? String {
            self.imageURL = imageURL
        }
        
        // Rating Image URL
        if let ratingImageURL = dictionary["rating_img_url"] as? String {
            self.ratingImageURL = ratingImageURL
        }
        
        // Num Reviews
        if let numReviews = dictionary["review_count"] as? Int {
            self.numReviews = numReviews
        }
        
        // Categories
        if let categories = dictionary["categories"] as? NSArray {
            self.categories = categories
        }
        
        // Address
        var tempAddress: String?
        if let addresses = dictionary.valueForKeyPath("location.address") as? NSArray {
            if addresses.count > 0 {
                if let street = addresses[0] as? String {
                    self.address = street
                }
            }
        }
        
        if let neighborhoods = dictionary.valueForKeyPath("location.neighborhoods") as? NSArray {
            if neighborhoods.count > 0 {
                if let neighborhood = neighborhoods[0] as? String {
                    if (self.address != nil) {
                        self.address! += String(format: ", %@", neighborhood)
                    } else {
                        self.address = neighborhood
                    }
                }
            }
        }
    }
    
    class func businessesWithDictionaries(dictionaries: [NSDictionary]) -> NSArray {
        var businesses: NSMutableArray = []
        
        for dictionary in dictionaries {
            let business = Business(dictionary: dictionary)
            businesses.addObject(business)
        }
        
        return businesses as NSArray
    }
}
