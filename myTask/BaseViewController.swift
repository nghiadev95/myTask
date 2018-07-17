//
//  BaseViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ToastManager.shared.position = .center
    }
    
    func push(viewControllerIdentifier: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier) else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushTaskListDetailViewController(with data: TaskList) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "taskListDetailViewController") as? TaskListDetailViewController else {
            return
        }
        vc.taskList = data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushNewTaskListViewController(with data: TaskList?) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newTaskListViewController") as? NewTaskListViewController else {
            return
        }
        vc.taskList = data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushNewTaskViewController(taskList: TaskList, task: Task?) {

    }
    
    func pushProfileViewController(with user: User) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController else {
            return
        }
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func makeToast(message: String) {
        self.navigationController?.view.makeToast(message)
    }
}
