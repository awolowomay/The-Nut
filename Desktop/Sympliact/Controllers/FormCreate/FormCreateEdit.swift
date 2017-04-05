//
//  FormCreate.swift
//  MedProj
//
//  Created by Michael McKenna on 2/7/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import UIKit

class FormCreateEdit: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var scribbleButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func addCheckbox(_ sender: Any) {
        let question = Question()
        question.type = "checkbox"
        questions.append(question)
    }
    
    @IBAction func addTextType(_ sender: Any) {
        let question = Question()
        question.type = "text_field"
        questions.append(question)
    }
    
    @IBAction func addChoiceList(_ sender: Any) {
        let question = Question()
        question.type = "choice_list"
        questions.append(question)
    }

    // MARK: Properties
    
    var questions = [Question]() {
        didSet {
            tableView.insertRows(at: [IndexPath(row: questions.count - 1, section: 0)], with: .none)
            if questions.count <= 4 {
                let cell = tableView.cellForRow(at: IndexPath(row: questions.count - 1, section: 0))!
                let originalFrame = cell.frame
                cell.frame = CGRect(x: 0, y: tableView.bounds.height, width: originalFrame.width, height: originalFrame.height)
                UIView.animate(withDuration: 0.6, animations: { cell.frame = originalFrame })
            }
        }
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        tableView.tableFooterView = UIView()
        
//        checkboxButton.setBackgroundColor(color: Colors.greenWithAlpha, forState: .highlighted)
//        scribbleButton.setBackgroundColor(color: Colors.GreenWithAlpha, forState: .highlighted)
//        listButton.setBackgroundColor(color: Colors.GreenWithAlpha, forState: .highlighted)
    }
    
    // MARK: Tableview
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdminCreateQuestionCell
        cell.configure(question, indexPath, self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    // MARK: Custom Methods
    
    func addChoice(sender: UIButton) {
        let ip = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: ip) as! AdminCreateQuestionCell
        let option = Option()
        
        cell.choiceTextField.text = ""
        
        questions[ip.row].options.append(option)
        questions[ip.row].value = cell.questionField.text!
        tableView.reloadRows(at: [ip], with: .none)
    }
    
    //closes keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
