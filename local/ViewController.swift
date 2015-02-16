//
//  ViewController.swift
//  local
//
//  Created by Eric Huang on 2/9/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    let yelpConsumerKey = "Zw9mMQb3DoXmAJ2359GJDg"
    let yelpConsumerSecret = "5YT6bn3GXi0RZ1M_vV7UHgWkncM"
    let yelpToken = "cgO9Q_fk2gTCiCNlmcwVy14JATKV_XCz"
    let yelpTokenSecret = "LzPk9vwK4tq7zUARypZCcRYudgw"
    var client: YelpClient!
    var businesses: [Business] = []
    var searchBar = UISearchBar()
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var businessesTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var filters: NSMutableDictionary = [
        "category_filter": "",
        "sort": "0",
        "radius_filter": "10"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noResultsLabel.hidden = true
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getBusinesses", forControlEvents: UIControlEvents.ValueChanged)
        
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 87
        businessesTableView.addSubview(refreshControl)
        businessesTableView.hidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "onFilterButton")
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        getBusinesses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBusinesses() {
        let searchTerm = searchBar.text
        self.noResultsLabel.hidden = true
    
        client.searchWithTerm(searchTerm, filters: filters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            self.spinner.stopAnimating()
            self.businessesTableView.hidden = false
            self.refreshControl?.endRefreshing()
            
            let dictionaries = response["businesses"] as [NSDictionary]
            self.businesses = Business.businessesWithDictionaries(dictionaries) as [Business]
            
            if self.businesses.count == 0 {
                self.businessesTableView.hidden = true
                self.noResultsLabel.hidden = false
            }
            
            self.businessesTableView.reloadData()
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        businessesTableView.hidden = true
        spinner.startAnimating()
        getBusinesses()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        cell.setBusiness(businesses[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: BusinessCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.thumbnail.image = nil
        cell.ratingImage.image = nil
    }
    
    func onFilterButton() {
        let vc:FiltersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FiltersViewController") as FiltersViewController
        vc.delegate = self
        vc.filters = filters
        var nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }
    
    func filtersViewController(filterViewController: FiltersViewController, didChangeFilters filters: NSMutableDictionary) {
        self.filters = filters as NSMutableDictionary
        getBusinesses()
    }
}