//
//  TaskService.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/3/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import RealmSwift

final class TaskService {
    public static let shared = TaskService()
    private init() {}
    
    func add(taskInfo: Task, taskList: TaskList, callBack: (Bool, Task) -> Void) {
        try! RealmService.shared.reference().write {
            let newTask = Task()
            newTask.name = taskInfo.name
            newTask.dueDate = taskInfo.dueDate
            newTask.isCompleted = taskInfo.isCompleted
            newTask.shouldNotification = taskInfo.shouldNotification
            newTask.lat = taskInfo.lat
            newTask.long = taskInfo.long
            newTask.locationName = taskInfo.locationName
            taskList.tasks.append(newTask)
            callBack(true, newTask)
        }
    }
    
    func update(task: Task, taskInfo: Task, callBack: (Bool) -> Void) {
        try! RealmService.shared.reference().write {
            task.name = taskInfo.name
            task.dueDate = taskInfo.dueDate
            task.isCompleted = taskInfo.isCompleted
            task.shouldNotification = taskInfo.shouldNotification
            task.lat = taskInfo.lat
            task.long = taskInfo.long
            task.locationName = taskInfo.locationName
            RealmService.shared.reference().add(task, update: true)
        }
        callBack(true)
    }
    
    func delete(task: Task, callBack: (Bool, String) -> Void) {
        let id = task.id
        try! RealmService.shared.reference().write {
            RealmService.shared.reference().delete(task)
        }
        callBack(true, id)
    }
}

