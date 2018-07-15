//
//  NewTaskViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import SnapKit
import UserNotifications
import MapKit

class NewTaskViewController: BaseViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDueDate: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var swReminder: UISwitch!
    @IBOutlet weak var btnAdd: UIButton!
    
    var taskInfo: Task!
    var task: Task!
    var taskList: TaskList!
    var isShowingDatePicker = false
    var heightDatePickerCS: Constraint!
    var datePicker: UIDatePicker!
    var doneView: UIView!
    weak var delegate: NewTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePicker()
        tfName.delegate = self
        btnAdd.roundedButton(byCorners: [.allCorners], cornerRadii: CGSize(width: btnAdd.frame.width/2, height: btnAdd.frame.width/2))
    }
    
    func addDatePicker() {
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(updateDueDateLabel(datePicker:)), for: .valueChanged)
        
        doneView = UIButton()
        doneView.backgroundColor = .clear
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideDateTimePicker))
        doneView.addGestureRecognizer(tapGes)
        
        navigationController?.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { (m) in
            m.left.right.equalToSuperview()
            heightDatePickerCS = m.bottom.equalToSuperview().offset(270).constraint
            m.height.equalTo(220)
        }
        
        navigationController?.view.addSubview(doneView)
        doneView.snp.makeConstraints { (m) in
            m.left.right.top.equalToSuperview()
            m.bottom.equalTo(datePicker.snp.top)
        }
        doneView.isHidden = true
        if let task = task {
            taskInfo = task.clone()
            tfName.text = task.name
            tfDueDate.text = task.dueDate.shortDateTime()
            tfLocation.text = task.locationName
            swReminder.isOn = task.shouldNotification
            btnAdd.setTitle("UPDATE TASK", for: .normal)
        } else {
            taskInfo = Task()
            taskInfo.dueDate = Date()
            taskInfo.shouldNotification = false
            taskInfo.isCompleted = false
            taskInfo.lat = 0.0
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        pop(animated: true)
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        guard let name = tfName.text, !name.isEmpty else {
            makeToast(message: "Task name must not empty")
            return
        }
        if task != nil {
            TaskService.shared.update(task: task, taskInfo: taskInfo) { [weak self] (isSuccess) in
                if isSuccess {
                    self?.makeToast(message: "Update Task successful")
                } else {
                    self?.makeToast(message: "Have an error when update Task")
                }
                self?.pop(animated: true)
            }
        } else {
            TaskService.shared.add(taskInfo: taskInfo, taskList: taskList) { [weak self] (isSuccess, task) in
                if isSuccess {
                    self?.makeToast(message: "Add new Task successful")
                } else {
                    self?.makeToast(message: "Have an error when add new Task")
                }
                self?.pop(animated: true)
            }
        }
    }
    @objc func showDateTimePicker() {
        doneView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.datePicker.snp.updateConstraints({ (m) in
                self.heightDatePickerCS.update(offset: 0)
                self.navigationController?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func hideDateTimePicker() {
        doneView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.datePicker.snp.updateConstraints({ (m) in
                self.heightDatePickerCS.update(offset: 270)
                self.navigationController?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func remindSwitchChanged() {
        if swReminder.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    print("Granted!!")
                } else {
                    self.swReminder.isOn = false
                    self.navigationController?.view.makeToast("You must grant notification for app")
                    print("Denied!!")
                }
            }
        }
        taskInfo.shouldNotification = swReminder.isOn
    }
    
    @IBAction func btnDueDatePressed(_ sender: Any) {
        showDateTimePicker()
    }
    
    
    @IBAction func btnLocationPressed(_ sender: Any) {
        let mapVC = MapViewController()
        if taskInfo.lat != 0.0 {
            mapVC.selectedLocation = CLLocation(latitude: taskInfo.lat, longitude: taskInfo.long)
        }
        mapVC.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func updateDueDateLabel(datePicker: UIDatePicker) {
        tfDueDate.text = datePicker.date.shortDateTime()
        taskInfo?.dueDate = datePicker.date
    }
}

extension NewTaskViewController: MapViewControllerDelegate {
    func mapViewController(_ controller: MapViewController, didSelectedLocation location: MKPlacemark) {
        taskInfo.lat = location.coordinate.latitude
        taskInfo.long = location.coordinate.longitude
        taskInfo.locationName = UtilsFunc.parseAddress(selectedItem: location)
        tfLocation.text = taskInfo.locationName
    }
}

extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
