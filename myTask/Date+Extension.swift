//
//  NSDate+Extentsion.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/8/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import Foundation

extension Date {
    func shortDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
    
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self).capitalized
    }
    
    func getSortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: self)
    }
}
