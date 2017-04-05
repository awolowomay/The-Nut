//
//  UserEditForTextCell.swift
//  MedProj
//
//  Created by William Flores on 2/25/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit

class UserEditForTextCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(question: Question) {
        questionLabel.text = question.value
        
        let answerList = question.answers
        
        guard let answer = answerList.first else {
            return
        }

        answerTextField.text = answer.value
    }
    
}
