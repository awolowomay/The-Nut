//
//  User.swift
//  MedProj
//
//  Created by Michael McKenna on 2/2/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var email = ""
    dynamic var dirty = false
    dynamic var destroy = false
    
    let questionnaires = List<Questionnaire>() // one-to-many relationship with questionnaires

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
                print(id)
            }
        } else {
            try! realm.write { realm.add(self, update: true) } // update
        }
        
    }
    
    func delete() {
        guard let realm = realm else {
            print("User: Error retrieving the realm")
            return
        }
        
        try! realm.write { realm.delete(self) }
    }
    
    func getCurrentUser() -> User {
        guard let realm = realm, let user = realm.objects(User.self).first else {
            print("User: Error retrieving the realm")
            return User()
        }
        
        return user
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
