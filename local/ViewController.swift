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
    
    var businesses: [Business] = []

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
            let dictionaries = response["businesses"] as [NSDictionary]
            self.businesses = Business.businessesWithDictionaries(dictionaries) as [Business]
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
        self.businesses = []
        searchBar.endEditing(true)
//        
//        client.searchWithTerm(searchBar.text, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println(response)
//            self.businesses = response["businesses"] as [NSDictionary]
//            self.businessesTableView.reloadData()
//            
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println(error)
//        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        
        cell.setBusiness(businesses[indexPath.row])
   
        
        return cell
    }

}

