//
//  User.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/16/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import RealmSwift

class User: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
