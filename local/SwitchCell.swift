//
//  SwitchCell.swift
//  local
//
//  Created by Eric Huang on 2/15/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchCell(switchCell:SwitchCell, didUpdateValue value: Bool)
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var on: Bool?
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func valueDidChange(sender: UISwitch) {
        if let delegate = delegate {
            delegate.switchCell(self, didUpdateValue: toggleSwitch.on)
        }
    }
    
    func setOn(on: Bool) {
        toggleSwitch.setOn(on, animated: false)
    }
    
    func setOn(on: Bool, animated: Bool) {
        toggleSwitch.setOn(on, animated: true)
    }
}
