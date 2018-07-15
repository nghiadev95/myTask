//
//  TaskListCollectionViewCell.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/13/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class TaskListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumOfTask: UILabel!
    
    func update(with data: TaskList) {
        imgIcon.image = UIImage(named: AppConstant.icons[data.iconId])
        lbName.text = data.name
        lbNumOfTask.text = "\(data.tasks.count) tasks"
    }
}
