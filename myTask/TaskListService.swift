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
    
    func add(name: String, iconId: Int, callBack: ((Bool, TaskList) -> Void)?) {
        try! RealmService.shared.reference().write {
            let newTaskList = TaskList()
            newTaskList.name = name
            newTaskList.iconId = iconId
            RealmService.shared.reference().add(newTaskList)
            callBack?(true, newTaskList)
        }
    }
    
    func update(taskList: TaskList, newName: String, newIconId: Int, callBack: (Bool, TaskList) -> Void) {
        try! RealmService.shared.reference().write {
            taskList.name = newName
            taskList.iconId = newIconId
            callBack(true, taskList)
        }
        
    }
    
    func delete(taskList: TaskList, callBack: (Bool) -> Void) {
        try! RealmService.shared.reference().write {
            RealmService.shared.reference().delete(taskList)
        }
        callBack(true)
    }
    
    func getNumberOfTaskList() -> Int {
        return RealmService.shared.reference().objects(TaskList.self).count
    }
    
    func createDefaultTaskListIfNeeded() {
        if getNumberOfTaskList() == 0 {
            let names = ["Daily Schedule", "Personal Errands", "Work Projects", "Grocery List", "Other"]
            
            for index in 0...4 {
                add(name: names[index], iconId: index, callBack: nil)
            }
        }
    }
}
