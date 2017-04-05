//
//  SectionHeader.swift
//  MedProj
//
//  Created by Michael McKenna on 3/3/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addQuestionButton: UIButton!
    
    func configure(delegate: QuestionListTVC, section: Int) {
        tag = section
        titleLabel.text = delegate.sections[section].name
        addQuestionButton.tag = section
        addQuestionButton.addTarget(
            delegate, action: #selector(delegate.addQuestion(sender:)),
            for: .touchUpInside)
        
        //for editing section, when a user taps on the view
        let gesture = UITapGestureRecognizer(target: delegate, action: #selector(delegate.editSection(sender:)))
        addGestureRecognizer(gesture)
    }
}
