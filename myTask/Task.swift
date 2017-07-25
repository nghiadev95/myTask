//
//  Task.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import RealmSwift

class Task: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var isCompleted = false
}
