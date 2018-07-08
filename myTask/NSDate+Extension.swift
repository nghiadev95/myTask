//
//  NSDate+Extentsion.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/8/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import Foundation

extension Date {
    func shortDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
