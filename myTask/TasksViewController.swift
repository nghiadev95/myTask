//
//  TasksViewController.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var taskList: TaskList!
    var openTasks: Results<Task>!
    var completedTasks : Results<Task>!
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIControl()
        reloadTaskList()
    }
    
    func setupUIControl() {
        navigationItem.title = taskList.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openTaskView))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    func addNewTask() {
        openTaskView()
    }
    
    func reloadTaskList() {
        completedTasks = self.taskList.tasks.filter("isCompleted = true")
        openTasks = self.taskList.tasks.filter("isCompleted = false")
    }
    
    @objc func openTaskView() {
        let taskVC = NewTaskViewController(style: .grouped)
        if selectedTask != nil {
            taskVC.task = selectedTask
        }
        taskVC.taskList = taskList
        taskVC.delegate = self
        navigationController?.pushViewController(taskVC, animated: true)
    }
}

extension TasksViewController: NewTaskViewControllerDelegate {
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingAdding item: Task) {
        let section = item.isCompleted ?  1 : 0
        let insertedList = item.isCompleted ? completedTasks : openTasks
        self.tableView.insertRows(at: [IndexPath(row: insertedList!.count - 1, section: section)], with: .automatic)
        self.selectedTask = nil
    }
    
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingEditing item: Task) {
        self.tableView.reloadData()
        self.selectedTask = nil
    }
}

extension TasksViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return openTasks != nil ? openTasks.count : 0
        }
        return completedTasks != nil ? completedTasks.count : 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Open" : "Completed"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")
        let task = indexPath.section == 0 ? openTasks[indexPath.row] : completedTasks[indexPath.row]
        cell?.textLabel?.text = task.name
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = indexPath.section == 0 ? openTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [unowned self] (action, index) in
            self.selectedTask = task
            self.openTaskView()
        }
        editAction.backgroundColor = AppConstant.EDIT_ACTION_BG_COLOR
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            TaskService.shared.delete(task: task, callBack: { (isSuccess) in
                if isSuccess {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
        
        let doneAction = UITableViewRowAction(style: .default, title: "Done") { (action, index) in
            TaskService.shared.update(task: task, newName: task.name, isComplete: true, callBack: { (isSuccess) in
                if isSuccess {
                    self.tableView.reloadData()
                }
            })
        }
        doneAction.backgroundColor = AppConstant.DONE_ACTION_BG_COLOR
        
        return indexPath.section == 0 ? [editAction,deleteAction,doneAction] : [editAction,deleteAction]
    }
}
