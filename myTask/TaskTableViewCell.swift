//
//  TaskTableViewCell.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet weak var lbDueTime: UILabel!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func update(with data: Task) {
        lbName.text = data.name
        lbLocation.text = data.locationName
        lbDueDate.text = data.dueDate.getMediumDate()
        lbDueTime.text = data.dueDate.getShortTime()
        imgNotification.isHidden = !data.shouldNotification
        imgCheck.isHighlighted = data.isCompleted
    }
}
