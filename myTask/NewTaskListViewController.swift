//
//  NewTaskListViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class NewTaskListViewController: BaseViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var clvIcon: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    var taskList: TaskList?
    var selectedIcon: String?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clvIcon.delegate = self
        clvIcon.dataSource = self
        let layout = UICollectionViewFlowLayout()
        clvIcon.collectionViewLayout = layout
        btnAdd.roundedButton(byCorners: [.allCorners], cornerRadii: CGSize(width: btnAdd.frame.width/2, height: btnAdd.frame.width/2))
        
        if taskList != nil {
            tfName.text = taskList!.name
            selectedIndex = taskList!.iconId
            btnAdd.setTitle("UPDATE TASK", for: .normal)
            lbTitle.text = "Update Task List"
        }
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        guard let name = tfName.text, !name.isEmpty else {
            makeToast(message: "Task name must not empty")
            return
        }
        guard let iconId = selectedIndex else {
            makeToast(message: "You must select icon")
            return
        }
        if taskList != nil {
            TaskListService.shared.update(taskList: taskList!, newName: name, newIconId: iconId) { [weak self] (isSuccess, taskList) in
                if isSuccess {
                    self?.makeToast(message: "Update Task List successful")
                } else {
                    self?.makeToast(message: "Have an error when update Task List")
                }
                self?.pop(animated: true)
            }
        } else {
            TaskListService.shared.add(name: name, iconId: iconId) { [weak self] (isSuccess, taskList) in
                if isSuccess {
                    self?.makeToast(message: "Add new Task List successful")
                } else {
                    self?.makeToast(message: "Have an error when add new Task List")
                }
                self?.pop(animated: true)
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        pop(animated: true)
    }
}

extension NewTaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        cell.setIcon(iconName: AppConstant.icons[indexPath.row])
        if selectedIndex != nil && indexPath.row == selectedIndex {
            cell.updateCheckState(isChecked: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let index = selectedIndex {
            if selectedIndex == indexPath.row {
                return
            }
            let previousSelectedCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! IconCollectionViewCell
            previousSelectedCell.updateCheckState(isChecked: false)
        }
        selectedIndex = indexPath.row
        let selectedCell = collectionView.cellForItem(at: indexPath) as! IconCollectionViewCell
        selectedCell.updateCheckState(isChecked: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
