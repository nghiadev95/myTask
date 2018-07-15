//
//  TaskList.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var iconId: Int = -1
    let tasks = List<Task>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
