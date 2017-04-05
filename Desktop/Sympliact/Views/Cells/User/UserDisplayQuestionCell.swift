//
//  QuestionCellForDisplay.swift
//  MedProj
//
//  Created by William Flores on 2/22/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit

class UserDisplayQuestionCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(question: Question) {
        questionLabel.text = question.value
        let answerList = question.answers
        if let answer = answerList[answerList.endIndex].value {
            answerLabel.text = answer
        }else {
            answerLabel.text = ""
        }
    }

}
