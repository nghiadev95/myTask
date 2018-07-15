//
//  TaskListViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TaskListDetailViewController: BaseViewController {
    @IBOutlet weak var scOrderType: UISegmentedControl!
    @IBOutlet weak var vAnimateSC: UIView!
    @IBOutlet weak var tbTasks: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    var taskList: TaskList!
    var tasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = taskList.tasks.filter("TRUEPREDICATE")
        tbTasks.delegate = self
        tbTasks.dataSource = self
        setupSCOrderType()
        btnAdd.roundedButton(byCorners: [.topLeft], cornerRadii: CGSize(width: 8, height: 8))
        
//        for _ in 0...4 {
//            let task = Task()
//            task.createdAt = Date()
//            task.shouldNotification = true
//            task.isCompleted = false
//            task.locationName = "43/3 Ung Van Khiem, Phuong 26, Quan Binh Thanh"
//            task.dueDate = Date()
//            task.name = "Test task"
//            TaskService.shared.add(taskInfo: task, taskList: taskList, callBack: nil)
//        }
    }
    
    func setupSCOrderType() {
        scOrderType.backgroundColor = .clear
        scOrderType.tintColor = .clear
        scOrderType.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(hex: "7470A3")], for: .normal)
        scOrderType.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(hex: "FF4954")], for: .selected)
        scOrderType.addTarget(self, action: #selector(scOrderTypeValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func scOrderTypeValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.vAnimateSC.frame.origin.x = (self.scOrderType.frame.width / CGFloat(self.scOrderType.numberOfSegments)) * CGFloat(self.scOrderType.selectedSegmentIndex)
        }
        switch sender.selectedSegmentIndex {
        case 0:
            tasks = taskList.tasks.filter("TRUEPREDICATE")
        case 1:
            tasks = taskList.tasks.filter("isCompleted = true")
        case 2:
            tasks = taskList.tasks.filter("isCompleted = false")
        case 3:
            tasks = taskList.tasks.filter("shouldNotification = true")
        default:
            fatalError()
        }
        tbTasks.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        pop(animated: true)
    }
    
    @IBAction func btnSettingPressed(_ sender: Any) {
        pushNewTaskListViewController(with: taskList)
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        pushNewTaskViewController(taskList: taskList, task: nil)
    }
    
    func scheduleNotification(task: Task) {
        removeNotification(id: task.id)
        if task.shouldNotification && task.dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "You need to do now"
            content.body = task.name
            content.sound = UNNotificationSound.default()
            let dateComponent = Calendar(identifier: .gregorian).dateComponents([.month, .day, .hour, .minute], from: task.dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

}

extension TaskListDetailViewController: NewTaskViewControllerDelegate {
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingAdding item: Task) {
        tbTasks.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
        scheduleNotification(task: item)
    }
    
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingEditing item: Task) {
        let row = tasks.index(of: item)
        tbTasks.reloadRows(at: [IndexPath(row: row!, section: 0)], with: .automatic)
        scheduleNotification(task: item)
    }
}

extension TaskListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.update(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushNewTaskViewController(taskList: taskList, task: tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = tasks[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            TaskService.shared.delete(task: task, callBack: { (isSuccess, id) in
                if isSuccess {
                    self.tbTasks.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
        
        let doneAction = UITableViewRowAction(style: .default, title: "Done") { (action, index) in
            TaskService.shared.update(task: task, isCompleted: true, callBack: { (isSuccess) in
                if isSuccess {
                    self.scheduleNotification(task: task)
                    self.tbTasks.reloadRows(at: [indexPath], with: .automatic)
                }
            })
        }
        doneAction.backgroundColor = AppConstant.DONE_ACTION_BG_COLOR
        
        return [deleteAction,doneAction]
    }
}
