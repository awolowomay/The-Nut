//
//  Question.swift
//  MedProj
//
//  Created by Michael McKenna on 2/2/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

class Question: Object {
    dynamic var id = 0
    dynamic var type = "" //text_field, choice_list
    dynamic var value = ""
    dynamic var dirty = false
    dynamic var destroy = false
    
    // one-to-many relationships
    let answers = List<Answer>()
    let options = List<Option>()
    
    // one-to-one relationship for a question of type text_field (where there is no Option object that can point to the next question
    var linkedQuestion: Question? = nil
    
    func insertOrUpdate() {
        let realm = try! Realm()
        
        if id == 0 {
            try! realm.write {
                /*
                 once the object is synced with the server, we will be deleting the old one and replacing it with
                 the one in the response since the primary key cannot be changed. See https://github.com/realm/realm-java/issues/3589
                 */
                id = self.generateClientId()
                realm.add(self)
            }
        } else {
            try! realm.write { realm.add(self, update: true) } // update
        }
    }
    
    func delete() {
        let realm = try! Realm()

        try! realm.write {
            realm.delete(self)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
