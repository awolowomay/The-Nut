//
//  QuestionTVC.swift
//  MedProj
//
//  Created by Michael McKenna on 3/3/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionListTVC: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBAction func addSection(_ sender: Any) {
        addOrEditSection(name: "", Section(), questionnaire)
    }
    
    let realm = try! Realm()
    var questionnaire: Questionnaire!
    var sections: List<Section>!
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        sections = questionnaire.sections
        
        // Observe Results Notifications
        notificationToken = sections.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                for insertIndex in insertions {
                    tableView.insertSections(NSIndexSet(index: insertIndex) as IndexSet, with: .automatic)
                }
                for deleteIndex in deletions {
                    tableView.deleteSections(NSIndexSet(index: deleteIndex) as IndexSet, with: .automatic)
                }
                for modifyIndex in modifications {
                    tableView.reloadSections(NSIndexSet(index: modifyIndex) as IndexSet, with: .fade)
                }
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
            
            tableView.reloadData() //fixes issue where section headers are not updated after the deletion of a section
        }

    }
    
    deinit {
        notificationToken?.stop()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as? QuestionAndLinkCell else {
            return UITableViewCell()
        }
        let question = sections[indexPath.section].questions[indexPath.row]
        
        cell.linkedQuestionValue.text = ""
        cell.questionValue.text = question.value
        if let linkedQuestion = question.linkedQuestion {
            cell.linkedQuestionValue.text = "Linked to: \(linkedQuestion.value)"
        } else if question.options.count > 0 {
            cell.linkedQuestionValue.text = "Options: "
            for option in question.options {
                guard let value = option.value else { continue }
                cell.linkedQuestionValue.text = cell.linkedQuestionValue.text! + "\n○  \(value)"
            }
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as? SectionHeader else {
            return UIView()
        }

        sectionHeader.configure(delegate: self, section: section)
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let link = UITableViewRowAction(style: .normal, title: "Link") { (action, ip) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Admin", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LinkQuestion") as! LinkQuestionTVC
            let section = self.sections[ip.section]
            nextViewController.section = section
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        link.backgroundColor = Colors.greenWithAlpha
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, ip) in
            self.sections[ip.section].questions[ip.row].delete()
        }
        
        return [delete, link]
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ip = tableView.indexPathForSelectedRow, let dest = segue.destination as? CreateQuestion {
            let q = sections[ip.section].questions[ip.row]
            dest.question = q
            dest.isChoiceList = (q.type == "choice_list") ? true : false
            dest.options = Array(q.options)
            dest.section = sections[ip.section]
            dest.isEdit = true
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Custom Methods
    
    func addQuestion(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Admin", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CreateQuestion") as! CreateQuestion
        let section = sections[sender.tag]
        nextViewController.section = section
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func editSection(sender: UITapGestureRecognizer) {
        guard let sectionHeader = sender.view as? SectionHeader else { return }
        addOrEditSection(name: sectionHeader.titleLabel.text!, sections[sectionHeader.tag])
    }
    
    func addOrEditSection(name: String, _ section: Section, _ questionnaire: Questionnaire? = nil) {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "CreateQuestionnaireOrSection") as! CreateQuestionnaireOrSection
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.typeForSave = .forSection
        popController.section = section
        if let q = questionnaire {
            popController.questionnaire = q
        }
        popController.editText = name
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0) //no arrow
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }

}
