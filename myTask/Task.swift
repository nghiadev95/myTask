//
//  Task.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var isCompleted = false
    @objc dynamic var dueDate = Date()
    @objc dynamic var shouldNotification = false
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    @objc dynamic var locationName: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func clone() -> Task {
        let task = Task()
        task.name = name
        task.createdAt = createdAt
        task.isCompleted = isCompleted
        task.dueDate = dueDate
        task.shouldNotification = shouldNotification
        task.lat = lat
        task.long = long
        task.locationName = locationName
        return task
    }
}
