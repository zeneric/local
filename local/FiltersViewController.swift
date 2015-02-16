//
//  FiltersViewController.swift
//  local
//
//  Created by Eric Huang on 2/15/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filterViewController: FiltersViewController, didChangeFilters filters: NSMutableDictionary)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate, TextCellDelegate {
    var categories = ["Thai", "Japanese", "Chinese", "Salad"]
    var sortFilters = ["Best Match", "Distance", "Highest Rated"]
    var filters: NSMutableDictionary!
    var selectedCategories: NSMutableSet = NSMutableSet()
    @IBOutlet weak var filtersTableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancelButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "onApplyButton")
        
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onApplyButton() {
        if let delegate = delegate {
            delegate.filtersViewController(self, didChangeFilters: filters)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.delegate = self
            cell.setOn(selectedCategories.containsObject(categories[indexPath.row]), animated: false)
            cell.nameLabel.text = categories[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.delegate = self
            cell.setOn((filters["sort"] as String) == String(indexPath.row), animated: false)
            cell.nameLabel.text = sortFilters[indexPath.row]
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("TextCell") as TextCell
            cell.delegate = self
            cell.nameLabel.text = "Max Distance"
            cell.valueTextField.text = filters["radius_filter"] as? String
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categories.count
        case 1:
            return sortFilters.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Categories"
        case 1:
            return "Sort by"
        case 2:
            return "Additional"
        default:
            return ""
        }
    }
    
    func switchCell(switchCell: SwitchCell, didUpdateValue value: Bool) {
        let indexPath = filtersTableView.indexPathForCell(switchCell)!
        
        if indexPath.section == 0 {
            // Categories
            value ? selectedCategories.addObject(categories[indexPath.row]) : selectedCategories.removeObject(categories[indexPath.row])
            
            let selectedCategoriesArray = selectedCategories.allObjects as NSArray
            filters["category_filter"] = selectedCategoriesArray.componentsJoinedByString(",").lowercaseString
        } else if indexPath.section == 1 {
            // Sort
            filters["sort"] = String(indexPath.row)
            for index in 0..<sortFilters.count {
                let cell = filtersTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as SwitchCell
                if cell != switchCell {
                    cell.toggleSwitch.setOn(false, animated: true)
                }
            }
        }
    }
    
    func textCell(textCell: TextCell, didUpdateValue value: String) {
        filters["radius_filter"] = value
    }
}
