//
//  QuestionValueHeaderCell.swift
//  MedProj
//
//  Created by Michael McKenna on 3/5/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import Material

class QuestionValueHeaderCell: UITableViewCell {
    
    @IBOutlet weak var valueTextField: TextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueTextField.placeholderNormalColor = Color.white
        valueTextField.placeholderActiveColor = Color.white
        valueTextField.dividerNormalColor = Color.white
        valueTextField.dividerActiveColor = Color.white
        valueTextField.isClearIconButtonEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
