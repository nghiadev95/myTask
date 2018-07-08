//
//  NewTaskController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/2/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import SnapKit
import UserNotifications

class NewTaskViewController: UITableViewController {
    var nameCell = UITableViewCell()
    var doneCell = UITableViewCell()
    var dueDateCell = UITableViewCell()
    var remindCell = UITableViewCell()
    var datePickerCell = UITableViewCell()
    
    var taskNameTf: UITextField!
    var doneBtn: UIButton!
    var dueDateLabel: UILabel!
    var remindSwitch: UISwitch!
    var datePicker: UIDatePicker!
    
    var taskInfo: Task!
    var task: Task!
    var taskList: TaskList!
    var isUpdating: Bool!
    var isShowingDatePicker = true
    
    weak var delegate: NewTaskViewControllerDelegate?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
            taskInfo = task.clone()
            taskNameTf.text = task.name
            remindSwitch.isOn = task.shouldNotification
            doneBtn.setTitle("Update", for: .normal)
            isUpdating = true
        } else {
            taskInfo = Task()
            taskInfo.dueDate = Date()
            taskInfo.shouldNotification = false
            taskInfo.isCompleted = false
            isUpdating = false
        }
        datePicker.setDate(taskInfo!.dueDate, animated: false)
        dueDateLabel.text = taskInfo!.dueDate.shortDateTimeString()
        taskNameTf.becomeFirstResponder()
    }
    
    func remindSwitchChanged() {
        if remindSwitch.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    print("Granted!!")
                } else {
                    self.remindSwitch.isOn = false
                    self.navigationController?.view.makeToast("You must grant notification for app")
                    print("Denied!!")
                }
            }
        }
        taskInfo.shouldNotification = remindSwitch.isOn
    }
    
    func doneBtnPressed() {
        guard let name = taskNameTf.text, !name.isEmpty else {
            navigationController?.view.makeToast("Name must not empty")
            return
        }
        taskInfo.name = name
        if isUpdating {
            TaskService.shared.update(task: task, taskInfo: taskInfo) { (isSuccess) in
                if isSuccess {
                    delegate?.newTaskViewController(self, didFinishingEditing: task!)
                }
            }
        } else {
            TaskService.shared.add(taskInfo: taskInfo, taskList: taskList) { (isSuccess, addedTask) in
                if isSuccess {
                    delegate?.newTaskViewController(self, didFinishingAdding: addedTask)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateDueDateLabel(datePicker: UIDatePicker) {
        dueDateLabel.text = datePicker.date.shortDateTimeString()
        taskInfo?.dueDate = datePicker.date
    }
}

extension NewTaskViewController {
    override func loadView() {
        super.loadView()
        self.title = "Task detail"
        
        taskNameTf = UITextField()
        taskNameTf.placeholder = "Task name"
        nameCell.addSubview(taskNameTf)
        taskNameTf.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().offset(10)
            maker.bottom.right.equalToSuperview().offset(-10)
        }
        
        let titleRemindLabel = UILabel()
        titleRemindLabel.text = "Remind Me"
        remindCell.addSubview(titleRemindLabel)
        titleRemindLabel.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(10)
            m.centerY.equalToSuperview()
        }
        remindSwitch = UISwitch()
        remindSwitch.isOn = false
        remindSwitch.addTarget(self, action: #selector(remindSwitchChanged), for: .valueChanged)
        remindCell.addSubview(remindSwitch)
        remindSwitch.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-10)
            m.centerY.equalToSuperview()
        }
        
        let titleDueDatelabel = UILabel()
        titleDueDatelabel.text = "Due Date"
        dueDateCell.addSubview(titleDueDatelabel)
        titleDueDatelabel.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().offset(10)
        }
        dueDateLabel = UILabel()
        dueDateLabel.text = "None"
        dueDateCell.addSubview(dueDateLabel)
        dueDateLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(10)
        }
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(updateDueDateLabel(datePicker:)), for: .valueChanged)
        datePickerCell.addSubview(datePicker)
        datePicker.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview().offset(10)
            m.right.bottom.equalToSuperview().offset(-10)
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
}

extension NewTaskViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 && indexPath.row == 1 ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskNameTf.resignFirstResponder()
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
                return remindCell
            case 1:
                return dueDateCell
            case 2:
                return datePickerCell
            default:
                fatalError()
            }
        case 2:
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
            return "Action"
        case 2:
            return ""
        default:
            fatalError()
        }
    }
}
