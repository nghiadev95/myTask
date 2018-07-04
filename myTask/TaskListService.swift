//
//  TaskListService.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/2/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import RealmSwift

final class TaskListService {
    public static let shared = TaskListService()
    private init() {}
    
    func add(name: String, callBack: (Bool, TaskList) -> Void) {
        try! RealmService.shared.reference().write {
            let newTaskList = TaskList()
            newTaskList.name = name
            RealmService.shared.reference().add(newTaskList)
            callBack(true, newTaskList)
        }
    }
    
    func update(taskList: TaskList, newName: String, callBack: (Bool, TaskList) -> Void) {
        try! RealmService.shared.reference().write {
            taskList.name = newName
            callBack(true, taskList)
        }
        
    }
    
    func delete(taskList: TaskList, callBack: (Bool) -> Void) {
        try! RealmService.shared.reference().write {
            RealmService.shared.reference().delete(taskList)
        }
        callBack(true)
    }
}
