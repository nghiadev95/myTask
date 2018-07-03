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
    
    func add(name: String, taskList: TaskList, callBack: (Bool, Task) -> Void) {
        try! RealmService.shared.reference().write {
            let newTask = Task()
            newTask.name = name
            taskList.tasks.append(newTask)
            callBack(true, newTask)
        }
    }
    
    func update(task: Task, newName: String, isComplete: Bool = false, callBack: (Bool) -> Void) {
        try! RealmService.shared.reference().write {
            task.name = newName
            task.isCompleted = isComplete
        }
        callBack(true)
    }
    
    func delete(task: Task, callBack: (Bool) -> Void) {
        try! RealmService.shared.reference().write {
            RealmService.shared.reference().delete(task)
        }
        callBack(true)
    }
}

