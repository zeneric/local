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
    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBusiness(business: Business) {
        nameLabel.text = business.name
        addressLabel.text = business.address
        thumbnail.setImageWithURL(NSURL(string: business.imageURL!))
        ratingImage.setImageWithURL(NSURL(string: business.ratingImageURL!))
        distanceLabel.text = "0.2 mi"
    }

}
