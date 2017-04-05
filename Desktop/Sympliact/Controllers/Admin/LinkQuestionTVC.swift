//
//  LinkQuestionTVC.swift
//  MedProj
//
//  Created by Michael McKenna on 3/3/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

class LinkQuestionTVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    // MARK: Actions
    
    @IBAction func linkQuestion(_ sender: Any) {
        guard let ip = tableView.indexPathForSelectedRow else { return }
        let linkedQuestion = section.questions[ip.row]
        
        try! realm.write {
            // if the user wants to link a question to question
            if let question = question {
                question.linkedQuestion = linkedQuestion
            }
                // if the user wants to link a question to an option
            else if let option = option {
                option.linkedQuestion = linkedQuestion
            }
        }

    }
    
    // MARK: Properties
    
    var searchController: UISearchController!
    var section: Section!
    // the question object that we will be adding a linked question to; will not be nil if previous VC is LinkQuestionTVC
    var question: Question?
    // the option object that we will be adding a linked question to; will not be nil if previous VC is CreateQuestion
    var option: Option?
    var realm = try! Realm()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.setUp()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self    // so we can monitor text changes + others

        let attributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.systemFont(ofSize: 17)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        tableView.tableHeaderView = searchController.searchBar

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section.questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? SimpleTextCell else { return UITableViewCell() }
        cell.dataTextField.text = section.questions[indexPath.row].value
        return cell
    }
    
    // MARK: - UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {

    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
    }
    
    // MARK: - Search Methods
    
    func updateSearchResults(for searchController: UISearchController) {
     
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        tableView.reloadData()
    }



}
