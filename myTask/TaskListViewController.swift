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

class TaskListViewController: UIViewController {

    var lists: Results<TaskList>!
    var taskListTB: UITableView!
    private var isAscendingSort: Bool = false
    private var orderType: OrderType = .name
    
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
        taskListTB.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(showActionSheetChangeOrder))
        navigationItem.title = AppMessage.TASK_LIST
        
        taskListTB = UITableView()
        taskListTB.dataSource = self
        taskListTB.delegate = self
        taskListTB.register(TaskListTableViewCell.self, forCellReuseIdentifier: "TaskListCell")
        
        view.addSubview(taskListTB)
        taskListTB.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func addNewTaskList() {
        showInputDialog(isUpdate: false) { [unowned self] (isSuccess) in
            if isSuccess {
                self.taskListTB.insertRows(at: [IndexPath(row: self.lists.count - 1, section: 0)], with: .automatic)
            } else {
                self.view.makeToast("Add new Task List fail!!!")
            }
        }
    }
    
    func changeOrderSetting() {
        if orderType == OrderType.name {
            lists = lists.sorted(byKeyPath: "name", ascending: isAscendingSort)
        } else {
            lists = lists.sorted(byKeyPath: "createdAt", ascending: isAscendingSort)
        }
        taskListTB.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        let addAction = UIAlertAction(title: doneTitle, style: .default, handler: { [unowned self] (action) in
            guard let name = nameTextField.text else {
                callback(false)
                return
            }
            if name.isEmpty {
                self.view.makeToast("Task name must not empty!")
                return
            }
            if isUpdate {
                TaskListService.shared.update(taskList: taskList!, newName: name, callBack: callback)
            } else {
                TaskListService.shared.add(name: name, callBack: callback)
            }
        })
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @objc private func showActionSheetChangeOrder() {
        let typeVC = UIAlertController(title: "Change type", message: nil, preferredStyle: .actionSheet)
        
        typeVC.addAction(UIAlertAction(title: "Ascending", style: .default) { [unowned self] (action) in
            self.isAscendingSort = true
            self.changeOrderSetting()
        })
        typeVC.addAction(UIAlertAction(title: "Descending", style: .default) { [unowned self] (action) in
            self.isAscendingSort = false
            self.changeOrderSetting()
        })
        
        let alertVC = UIAlertController(title: "Change order", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Name", style: .default) { [unowned self] (action) in
            self.orderType = .name
            self.present(typeVC, animated: true, completion: nil)
        })
        alertVC.addAction(UIAlertAction(title: "Date Created", style: .default) { [unowned self] (action) in
            self.orderType = .date
            self.present(typeVC, animated: true, completion: nil)
        })
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] (action) in
            self.isAscendingSort = true
            self.dismiss(animated: true, completion: nil)
        })
    
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
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
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
        }
        editAction.backgroundColor = AppConstant.EDIT_ACTION_BG_COLOR
        let deleteAction = UITableViewRowAction(style: .default, title: AppMessage.DELETE) { (action, index) in
            TaskListService.shared.delete(taskList: self.lists[indexPath.row], callBack: { [unowned self] (isSuccess) in
                if isSuccess {
                    self.taskListTB.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                }
            })
        }
        return [editAction, deleteAction]
    }
}
