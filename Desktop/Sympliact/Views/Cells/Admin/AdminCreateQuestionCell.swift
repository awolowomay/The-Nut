//
//  QuestionCellForCreate.swift
//  MedProj
//
//  Created by Michael McKenna on 2/7/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import UIKit

class AdminCreateQuestionCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var addChoiceButton: UIButton!
    @IBOutlet weak var choiceButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var contentSubView: UIView!
    @IBOutlet weak var choiceTextField: UITextField!
    @IBOutlet weak var choiceHeight: NSLayoutConstraint!
    
    enum QuestionType: String {
        case choiceList = "choice_list"
        case checkbox = "checkbox"
        case textField = "text_field"
    }
    var questionType: QuestionType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        choiceButtonHeight.constant = 0
        addChoiceButton.isHidden = true
        choiceTextField.isHidden = true
        choiceHeight.constant = 0
        descLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentSubView.addDropShadow()
        addChoiceButton.addDropShadow()
        addChoiceButton.layer.cornerRadius = 5.0
        contentSubView.layer.cornerRadius = 5.0
    }
    
    func configure(_ question: Question, _ indexPath: IndexPath, _ delegate: AnyObject) {
        questionType = QuestionType(rawValue: question.type)
        guard let questionType = questionType else { return }
        questionField.text = question.value
        
        switch questionType {
        case .choiceList:
            typeLabel.text = "Choice List"
            choiceButtonHeight.constant = 30
            addChoiceButton.isHidden = false
            choiceHeight.constant = 30
            choiceTextField.isHidden = false
            addChoiceButton.tag = indexPath.row
            
//            if let delegate = delegate as? FormCreate {
//                addChoiceButton.addTarget(delegate, action: #selector(delegate.addChoice), for: .touchUpInside)
//            } else if let delegate = delegate as? UserFormDisplayCell {
//                addChoiceButton.addTarget(delegate, action: #selector(delegate.addChoice), for: .touchUpInside)
//            }

            for option in question.options {
                guard let text = descLabel.text, let choice = option.value else { return }
                descLabel.text = (text.isEmpty)
                ? "○  \(choice)"
                : text + "\n○  \(choice)"
            }
        case .checkbox:
            typeLabel.text = "Checkbox"
        case .textField:
            typeLabel.text = "Text Field"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        choiceButtonHeight.constant = 0
        addChoiceButton.isHidden = true
        choiceTextField.isHidden = true
        choiceHeight.constant = 0
        descLabel.text = ""
    }

}
