//
//  OptionCell.swift
//  MedProj
//
//  Created by Michael McKenna on 3/5/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {

    @IBOutlet weak var optionValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(delegate: CreateQuestion, ip: IndexPath) {
        optionValue.delegate = delegate
        let option = delegate.options[ip.row]
        optionValue.addTarget(delegate, action: #selector(delegate.textFieldDidChange(_:)), for: .editingChanged)
        optionValue.tag = ip.row
        optionValue.text = option.value
    }

}
