//
//  ViewController.swift
//  local
//
//  Created by Eric Huang on 2/9/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var client: YelpClient!
    let yelpConsumerKey = "Zw9mMQb3DoXmAJ2359GJDg"
    let yelpConsumerSecret = "5YT6bn3GXi0RZ1M_vV7UHgWkncM"
    let yelpToken = "cgO9Q_fk2gTCiCNlmcwVy14JATKV_XCz"
    let yelpTokenSecret = "LzPk9vwK4tq7zUARypZCcRYudgw"

    var searchBar = UISearchBar()
    
    var businesses: [NSDictionary]! = []

    @IBOutlet weak var businessesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        businessesTableView.separatorInset = UIEdgeInsetsZero

        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.businesses = response["businesses"] as [NSDictionary]
            self.businessesTableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Searching")
        self.businesses = []
        println(businesses.count)
        searchBar.endEditing(true)
        
        client.searchWithTerm(searchBar.text, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println(response["businesses"][0] as NSString)
            println(response)
            self.businesses = response["businesses"] as [NSDictionary]
            self.businessesTableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(businesses.count)
        
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("CellAtRow-\(indexPath.row)")
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        var business = businesses[indexPath.row]
        
        
        cell.nameLabel.text = business["name"] as? String
        
        // Thumbnail
        if let imageURL = business["image_url"] as? String {
            cell.thumbnail.setImageWithURL(NSURL(string: imageURL))
        }

        // Categories
        var category = ""
        if let categories = business["categories"] as? NSArray {
            category = categories[0][0] as String
        }
        cell.categoryLabel.text = category
        
        // Address
        var displayAddress = ""
        if let addresses = business.valueForKeyPath("location.address") as? NSArray {
            if addresses.count > 0 {
                if let address = addresses[0] as? String {
                    displayAddress = address
                }
            }
        }
        if let neighborhoods = business.valueForKeyPath("location.neighborhoods") as? NSArray {
            var neighborhood = neighborhoods[0] as? String
            displayAddress = "\(displayAddress), \(neighborhood)"
        }
        cell.addressLabel.text = displayAddress
        
        return cell
    }

}

