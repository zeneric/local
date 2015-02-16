//
//  TextCell.swift
//  local
//
//  Created by Eric Huang on 2/15/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

protocol TextCellDelegate: class {
    func textCell(textCell:TextCell, didUpdateValue value: String)
}

class TextCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var value: String!
    weak var delegate: TextCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        valueTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func textFieldDidEndEditing(textField: UITextField) {
        value = valueTextField.text

        if let delegate = delegate {
            delegate.textCell(self, didUpdateValue: value!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}
