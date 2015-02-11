//
//  BusinessCell.swift
//  local
//
//  Created by Eric Huang on 2/9/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
