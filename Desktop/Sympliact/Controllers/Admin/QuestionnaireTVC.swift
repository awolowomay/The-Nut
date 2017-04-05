//
//  QuestionnaireTVC.swift
//  MedProj
//
//  Created by Michael McKenna on 3/2/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionnaireTVC: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    let realm = try! Realm()
    var notificationToken: NotificationToken? = nil
    var questionnaires: Results<Questionnaire>!
    
    @IBAction func toPopover(_ sender: Any) {
        self.performSegue(withIdentifier: "toPopover", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        questionnaires = realm.objects(Questionnaire.self)
        
        // Observe Results Notifications
        notificationToken = questionnaires.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
        
    }
    
    deinit {
        notificationToken?.stop()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaires.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SimpleTextCell else {
            return UITableViewCell()
        }
        
        let questionnaire = questionnaires[indexPath.row]
        cell.dataTextField.text = questionnaire.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CreateQuestionnaireOrSection, let controller = dest.popoverPresentationController {
            dest.typeForSave = .forQuestionnaire
            controller.delegate = self
            controller.sourceView = self.view
            controller.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        } else if let dest = segue.destination as? QuestionListTVC, let ip = tableView.indexPathForSelectedRow {
            dest.questionnaire = questionnaires[ip.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, ip) in
            self.questionnaires[ip.row].delete()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, ip) in
            // get a reference to the view controller for the popover
            let popController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "CreateQuestionnaireOrSection") as! CreateQuestionnaireOrSection
            
            // set the presentation style
            popController.modalPresentationStyle = .popover
            popController.typeForSave = .forQuestionnaire
            popController.questionnaire = self.questionnaires[ip.row]
            popController.editText = self.questionnaires[ip.row].name
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0) //no arrow
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = self.view
            popController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        
        return [delete, edit]
    }

    // MARK: Navigation
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }


}
