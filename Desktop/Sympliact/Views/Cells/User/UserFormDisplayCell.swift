//
//  FormDisplayCell.swift
//  MedProj
//
//  Created by William Flores on 2/22/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

class UserFormDisplayCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:  Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    //var form: Form?
    var questions = List<Question>()
    var isEdit = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        
//        if let form = form {
//            questions = form.questions
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = questions[indexPath.row]
        
        
        if isEdit {

            switch question.type {
                
            case "text_field":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "textEditCell") as? UserEditForTextCell else {
                    return UITableViewCell()
                }
                cell.configure(question: question)
                return cell
            
            case "checkbox":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell") as? UserEditForCheckBoxCell else {
                    return UITableViewCell()
                }
                cell.configure(question: question)
                return cell
        
            case "choice_list":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "choiceListCell") as? UserEditForChoiceListCell else {
                    return UITableViewCell()
                }
                cell.configure(question: question)
                return cell
        
            default:
                return UITableViewCell()
            
            }
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell") as? UserDisplayQuestionCell else {
                return UITableViewCell()
            }
            cell.configure(question: question)
            return cell
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    // MARK: Custom methods
//    
//    func configure(form: Form, isEdit: Bool) {
//        self.form = form
//        self.isEdit = isEdit
//    }
    
    func addChoice(sender: UIButton) {
        let ip = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: ip) as! AdminCreateQuestionCell
        let option = Option()
        
        cell.choiceTextField.text = ""
        
        questions[ip.row].options.append(option)
        questions[ip.row].value = cell.questionField.text!
        tableView.reloadRows(at: [ip], with: .none)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
