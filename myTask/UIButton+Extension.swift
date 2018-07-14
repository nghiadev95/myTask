//
//  UIView+Extension.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/14/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

extension UIButton{
    func roundedButton(byCorners: UIRectCorner){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: byCorners,
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
