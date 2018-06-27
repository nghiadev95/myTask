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
    var addAction: UIAlertAction!
    var openTasks: Results<Task>!
    var completedTasks : Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIControl()
        readTaskListAndReloadTableData()
    }
    
    func setupUIControl() {
        navigationItem.title = taskList.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    func addNewTask() {
        showAlertBox(task: nil)
    }
    
    func readTaskListAndReloadTableData() {
        completedTasks = self.taskList.tasks.filter("isCompleted = true")
        openTasks = self.taskList.tasks.filter("isCompleted = false")
        tableView.reloadData()
    }
    
    func showAlertBox(task: Task!) {
        var nameTask = ""
        var title = "New Task"
        var doneTitle = "Create"
        if task != nil{
            title = "Update Task"
            doneTitle = "Update"
            nameTask = task.name
        }
        let alertController = UIAlertController(title: title, message: "Enter name of task", preferredStyle: .alert)
        var nameTextField: UITextField!
        alertController.addTextField { (textfield) in
            nameTextField = textfield
            textfield.text = nameTask
            textfield.placeholder = "My Task"
            textfield.addTarget(self, action: #selector(self.nameTextFieldChangeValue), for: .editingChanged)
        }
        addAction = UIAlertAction(title: doneTitle, style: .default, handler: { (action) in
            guard let name = nameTextField.text else {
                return
            }
            if task != nil {
                //Update
                try! RealmService.shared.reference().write {
                    task.name = name
                    self.readTaskListAndReloadTableData()
                }
            } else {
                //Create
                let newTask = Task()
                newTask.name = name
                try! RealmService.shared.reference().write {
                    self.taskList.tasks.append(newTask)
                    self.readTaskListAndReloadTableData()
                }
            }
        })
        addAction.isEnabled = false
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func nameTextFieldChangeValue(nameTextField: UITextField) {
        addAction.isEnabled = (nameTextField.text?.characters.count)! > 0
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
        
        if section == 0{
            return "Open"
        }
        return "Completed"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")
        var task: Task!
        if indexPath.section == 0 {
            task = openTasks[indexPath.row]
        }
        else{
            task = completedTasks[indexPath.row]
        }
        
        cell?.textLabel?.text = task.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task: Task!
        if indexPath.section == 0 {
            task = openTasks[indexPath.row]
        }
        else{
            task = completedTasks[indexPath.row]
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            self.showAlertBox(task: task)
        }
        editAction.backgroundColor = UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            try! RealmService.shared.reference().write {
                RealmService.shared.reference().delete(task)
                self.readTaskListAndReloadTableData()
            }
        }
        
        let doneAction = UITableViewRowAction(style: .default, title: "Done") { (action, index) in
            try! RealmService.shared.reference().write {
                task.isCompleted = true
                self.readTaskListAndReloadTableData()
            }
        }
        doneAction.backgroundColor = UIColor(red: 0/225, green: 118/255, blue: 255/255, alpha: 1)
        
        return indexPath.section == 0 ? [editAction,deleteAction,doneAction] : [editAction,deleteAction]
    }
}
