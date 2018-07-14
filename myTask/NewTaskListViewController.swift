//
//  NewTaskListViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class NewTaskListViewController: UIViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var clvIcon: UICollectionView!
    
    @IBOutlet weak var btnAdd: UIButton!
    let iconNames = ["allSchedule", "personalErrands", "workProjects", "groceryList", "other", "gift", "internet", "music-player", "paper-plane", "star"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        clvIcon.delegate = self
//        clvIcon.dataSource = self
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        clvIcon.collectionViewLayout = layout
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//extension NewTaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
//        cell.setIcon(iconName: iconNames[indexPath.row])
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 30, height: 30)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//}
