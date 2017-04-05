//
//  Answer.swift
//  MedProj
//
//  Created by Michael McKenna on 2/25/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

class Answer: Object {
    dynamic var id = 0
    dynamic var value: String?
    dynamic var dirty = false
    dynamic var destroy = false
    
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
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
