//
//  TaskListTableViewCell.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import UIKit
import SnapKit

class TaskListTableViewCell: UITableViewCell {
    
    let img = { () -> UIImageView in
        let img = UIImageView()
        img.image = UIImage(named: "DisclosureIndicator")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "TaskListCell")
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.detailTextLabel?.frame = CGRect(x: (detailTextLabel?.frame.origin.x)! - (img.frame.width), y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
}
