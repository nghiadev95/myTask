//
//  IconCollectionViewCell.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/15/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    
    func setIcon(iconName: String) {
        imgIcon.image = UIImage(named: iconName)
    }
}
