//
//  NewTaskController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/2/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import SnapKit

class NewTaskViewController: UITableViewController {
    var nameCell = UITableViewCell()
    var doneCell = UITableViewCell()
    
    private var taskNameTf: UITextField!
    private var doneBtn: UIButton!
    
    var task: Task?
    var taskList: TaskList!
    var isUpdating: Bool!
    
    weak var delegate: NewTaskViewControllerDelegate?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isUpdating = task != nil ? true : false
    }
    
    override func loadView() {
        super.loadView()
        self.title = "Task detail"
        
        taskNameTf = UITextField()
        taskNameTf.placeholder = "Task name"
        taskNameTf.text = task != nil ? task!.name : ""
        nameCell.addSubview(taskNameTf)
        taskNameTf.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().offset(10)
            maker.bottom.right.equalToSuperview().offset(-10)
        }
        
        doneBtn = UIButton()
        
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(doneBtn.tintColor, for: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnPressed), for: .touchUpInside)
        doneCell.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalToSuperview()
            maker.height.equalTo(40)
        }
    }
    
    func doneBtnPressed() {
        if isUpdating {
            TaskService.shared.update(task: task!, newName: taskNameTf.text!, isComplete: true) { (isSuccess) in
                if isSuccess {
                    delegate?.newTaskViewController(self, didFinishingEditing: task!)
                }
            }
        } else {
            TaskService.shared.add(name: taskNameTf.text!, taskList: taskList) { (isSuccess, addedTask) in
                if isSuccess {
                    delegate?.newTaskViewController(self, didFinishingAdding: addedTask)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension NewTaskViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return nameCell
            default:
                fatalError()
            }
        case 1:
            switch indexPath.row {
            case 0:
                return doneCell
            default:
                fatalError()
            }
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Fill information"
        case 1:
            return ""
        default:
            fatalError()
        }
    }
}
