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
        reloadData()
    }
    
    func reloadData() {
        lists = RealmService.shared.reference().objects(TaskList.self)
        taskListTB.reloadData()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskList))
        navigationItem.title = AppMessage.TASK_LIST
        
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
        showInputDialog(isUpdate: false) { (isSuccess) in
            if isSuccess {
                
            } else {
                
            }
        }
    }
    
    func changeSortSetting() {
        if sortSegmentControl.selectedSegmentIndex == 0 {
            lists = lists.sorted(byKeyPath: "name")
        } else {
            lists = lists.sorted(byKeyPath: "createdAt", ascending: false)
        }
        taskListTB.reloadData()
    }
    
    func showInputDialog(isUpdate: Bool, taskList: TaskList? = nil, callback: @escaping (Bool) -> Void) {
        var nameTask = ""
        var title: String
        var doneTitle: String
        
        if isUpdate {
            guard taskList != nil else {
                callback(false)
                return
            }
            title = AppMessage.UPDATE_TASK_LIST
            doneTitle = AppMessage.UPDATE
            nameTask = taskList!.name
        } else {
            title = AppMessage.NEW_TASK_LIST
            doneTitle = AppMessage.CREATE
        }
        
        let alertController = UIAlertController(title: title, message: AppMessage.ENTER_THE_NAME_OF_TASK_LIST, preferredStyle: .alert)
        var nameTextField: UITextField!
        alertController.addTextField { (textfield) in
            nameTextField = textfield
            textfield.text = nameTask
            textfield.placeholder = AppMessage.MY_TASK_LIST
        }
        addAction = UIAlertAction(title: doneTitle, style: .default, handler: { (action) in
            guard let name = nameTextField.text else {
                callback(false)
                return
            }
            if name.isEmpty {
                self.view.makeToast("Task name must not empty!")
                return
            }
            if isUpdate {
                try! RealmService.shared.reference().write {
                    taskList!.name = name
                    self.reloadData()
                }
            } else {
                let newTaskList = TaskList()
                newTaskList.name = name
                try! RealmService.shared.reference().write {
                    let newRowIndex = self.lists.count
                    RealmService.shared.reference().add(newTaskList)
                    self.taskListTB.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .automatic)
                }
            }
        })
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    
}

extension TaskListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listTask = lists {
            return listTask.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppMessage.TASK_LIST_CELL_ID, for: indexPath)
        let taskList = lists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = "\(taskList.tasks.count) \(AppMessage.TASK)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TasksViewController()
        vc.taskList = lists[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: AppMessage.EDIT) { (action, index) in
            self.showInputDialog(isUpdate: true, taskList: self.lists[indexPath.row], callback: { (isSuccess) in
                if isSuccess {
                    
                } else {
                    
                }
            })
        }
        editAction.backgroundColor = AppConstant.EDIT_ACTION_BG_COLOR
        let deleteAction = UITableViewRowAction(style: .default, title: AppMessage.DELETE) { (action, index) in
            try! RealmService.shared.reference().write {
                RealmService.shared.reference().delete(self.lists[indexPath.row])
                self.taskListTB.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            }
        }
        return [editAction, deleteAction]
    }
}
