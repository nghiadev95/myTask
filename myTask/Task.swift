//
//  Task.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var isCompleted = false
}
