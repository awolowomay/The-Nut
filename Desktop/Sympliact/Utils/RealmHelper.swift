//
//  RealmHelper.swift
//  MedProj
//
//  Created by Michael McKenna on 3/3/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static let realm = try! Realm()
    
    static func deleteAllObjects() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
