//
//  CreateQuestion.swift
//  MedProj
//
//  Created by Michael McKenna on 3/5/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

class CreateQuestion: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Actions
    
    @IBAction func displayTextField(_ sender: Any) {
        isChoiceList = false
    }
    
    @IBAction func displayChoiceList(_ sender: Any) {
        isChoiceList = true
    }
    
    @IBAction func resetScreen(_ sender: Any) {
        self.isChoiceList = nil
    }
    
    @IBAction func saveQuestion(_ sender: Any) {
        //TODO: FIX FOR EDITING
        
        // prevents saving an empty object, such as if the user hit "reset" then "save"
        // also ensures we have a reference to the cell so that we can extract the question value
        guard let isChoiceList = isChoiceList,
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? QuestionValueHeaderCell else {
                return
        }
        
        question.insertOrUpdate()
        
        // insert/update options and add them to the question if they haven't been added already
        if isChoiceList {
            for option in options {
                option.insertOrUpdate()
                try! realm.write {
                    if !question.options.contains(option) {
                        question.options.append(option)
                    }
                }
            }
        }

        // updates question and adds it to the section if it hasn't been added already
        try! realm.write {
            question.value = cell.valueTextField.text!
            question.type = (isChoiceList) ? "choice_list" : "text_field"
            if !section.questions.contains(question) {
                section.questions.append(question)
            }
        }

        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var question = Question()
    let optionTag = 10
    let questionTag = 20
    var notificationToken: NotificationToken? = nil
    var section: Section!
    let realm = try! Realm()
    var isEdit = false
    var isChoiceList: Bool? {
        didSet {
            guard tableView != nil else { return }
            tableView.reloadData()
        }
    }
    var options = [Option]() {
        didSet {
            guard tableView != nil else { return }
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        bottomViewHeight.constant = (isEdit) ? 0 : 60
    }

    // MARK - Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionHeader") as? QuestionValueHeaderCell else { return UITableViewCell() }
            if !question.value.isEmpty {
                cell.valueTextField.text = question.value
            }
            return cell
        }
        // Add Choice cell
        else if indexPath.section == 1 && indexPath.row == tableView.numberOfRows(inSection: 1) - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addChoiceCell") as? AddChoiceCell else { return UITableViewCell() }
            return cell
        }
        // Option cell
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as? OptionCell else { return UITableViewCell() }
            cell.configure(delegate: self, ip: indexPath)
            return cell
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (isChoiceList == nil || isChoiceList == false) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isChoiceList == nil { return 0 }
        if section == 0 { return 1 }
        return options.count + 1 //adjusts for add choice button
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? AddChoiceCell {
            options.append(Option())
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let _ = tableView.cellForRow(at: indexPath) as? OptionCell else { return nil }
        
        let link = UITableViewRowAction(style: .normal, title: "Link") { (action, ip) in
            self.performSegue(withIdentifier: "toLinkQuestion", sender: self)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, ip) in
            let option = self.options[ip.row]
            if option.id != 0 {
                try! self.realm.write {
                    self.realm.delete(option)
                }
            }

            self.options.remove(at: ip.row)
            tableView.reloadData()
        }
        
        link.backgroundColor = Colors.greenWithAlpha
        
        return [link, delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let isChoiceList = isChoiceList, !isChoiceList {
            return tableView.bounds.height
        } else if indexPath.row == 0 && indexPath.section == 0 {
            return 75
        }
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidChange(_ textField: UITextField) {
        let row = textField.tag
        if row >= options.count {
            let option = Option()
            option.value = textField.text!
            options.append(option)
        } else {
            try! realm.write {
                options[row].value = textField.text!
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.resignFirstResponder()
    }
}
