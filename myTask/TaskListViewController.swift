//
//  TaskListViewController.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var lists: Results<TaskList>!
    var taskListTB: UITableView!
    var sortSegmentControl: UISegmentedControl!
    var addAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTaskListAndReloadTableData()
    }
    
    func readTaskListAndReloadTableData() {
        lists = RealmService.shared.reference().objects(TaskList.self)
        taskListTB.reloadData()
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskList))
        navigationItem.title = "Task List"
        
        
        sortSegmentControl = UISegmentedControl(items: ["A-Z","Date"])
        sortSegmentControl.selectedSegmentIndex = 0
        sortSegmentControl.addTarget(self, action: #selector(changeSortSetting), for: .valueChanged)
        view.addSubview(sortSegmentControl)
        sortSegmentControl.snp.makeConstraints { (maker) in
            maker.top.equalTo((self.navigationController?.navigationBar.frame.maxY)!)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(25)
        }
        
        taskListTB = UITableView()
        taskListTB.dataSource = self
        taskListTB.delegate = self
        taskListTB.register(TaskListTableViewCell.self, forCellReuseIdentifier: "TaskListCell")
        
        view.addSubview(taskListTB)
        taskListTB.snp.makeConstraints { (make) in
            make.top.equalTo(sortSegmentControl.snp.bottom).offset(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func addNewTaskList() {
        showAlertBox(taskList: nil)
    }
    
    func changeSortSetting() {
        if sortSegmentControl.selectedSegmentIndex == 0 {
            lists = lists.sorted(byKeyPath: "name")
        } else {
            lists = lists.sorted(byKeyPath: "createdAt", ascending: false)
        }
        taskListTB.reloadData()
    }
    
    func showAlertBox(taskList: TaskList!) {
        var nameTask = ""
        var title = "New Tasks List"
        var doneTitle = "Create"
        if taskList != nil{
            title = "Update Tasks List"
            doneTitle = "Update"
            nameTask = taskList.name
        }
        let alertController = UIAlertController(title: title, message: "Enter name of task list", preferredStyle: .alert)
        var nameTextField: UITextField!
        alertController.addTextField { (textfield) in
            nameTextField = textfield
            textfield.text = nameTask
            textfield.placeholder = "My TaskList"
            textfield.addTarget(self, action: #selector(self.nameTextFieldChangeValue), for: .editingChanged)
        }
        addAction = UIAlertAction(title: doneTitle, style: .default, handler: { (action) in
            guard let name = nameTextField.text else {
                return
            }
            if taskList != nil {
                //Update
                try! RealmService.shared.reference().write {
                    taskList.name = name
                    self.readTaskListAndReloadTableData()
                }
            } else {
                //Create
                let newTaskList = TaskList()
                newTaskList.name = name
                try! RealmService.shared.reference().write {
                    RealmService.shared.reference().add(newTaskList)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listTask = lists {
            return listTask.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = lists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = "\(taskList.tasks.count) Task"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TasksViewController()
        vc.tasklistViewController = self
        vc.taskList = lists[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            self.showAlertBox(taskList: self.lists[indexPath.row])
        }
        editAction.backgroundColor = UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1)
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            try! RealmService.shared.reference().write {
                RealmService.shared.reference().delete(self.lists[indexPath.row])
                self.readTaskListAndReloadTableData()
            }
        }
        return [editAction,deleteAction]
    }
}
