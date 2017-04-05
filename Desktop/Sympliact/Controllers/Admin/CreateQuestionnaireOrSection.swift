//
//  CreateQuestionnaire.swift
//  MedProj
//
//  Created by Michael McKenna on 3/6/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift
import Material

class CreateQuestionnaireOrSection: UIViewController, UITextFieldDelegate {

    // MARK: - Actions
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        try! realm.write {
            (typeForSave == .forSection)
            ? realm.delete(section)
            : realm.delete(questionnaire!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var valueTextField: TextField!
    
    // MARK: - Properties
    
    var questionnaire: Questionnaire?
    var section = Section()
    let realm = try! Realm()
    var editText = ""
    
    enum TypeForSave {
        case forQuestionnaire
        case forSection
    }
    
    var typeForSave: TypeForSave = .forQuestionnaire
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueTextField.placeholderNormalColor = Color.white
        valueTextField.placeholderActiveColor = Color.white
        valueTextField.dividerNormalColor = Color.white
        valueTextField.dividerActiveColor = Color.white
        valueTextField.isClearIconButtonEnabled = true
        valueTextField.delegate = self
        
        if typeForSave == .forSection {
            valueTextField.placeholder = "Enter section name"
            if !editText.isEmpty {
                valueTextField.text = editText
            }
        } else {
            valueTextField.placeholder = "Enter questionnaire name"
            if !editText.isEmpty {
                valueTextField.text = editText
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //purposely leaving out super
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Text field delegate
    
    //closes keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch typeForSave {
        case .forSection:
            section.insertOrUpdate()
            try! realm.write {
                section.name = textField.text!
                guard let questionnaire = questionnaire else { return }
                if !questionnaire.sections.contains(section) {
                    questionnaire.sections.append(section)
                }
            }
        case .forQuestionnaire:
            if questionnaire == nil {
                questionnaire = Questionnaire()
            }
            questionnaire?.insertOrUpdate()
            try! realm.write {
                questionnaire?.name = textField.text!
            }
        }

        dismiss(animated: true, completion: nil)
        return true
    }
    
    
}
