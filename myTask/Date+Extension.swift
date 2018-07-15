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
        formatter.dateStyle = .long
        formatter.timeStyle = .short
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
    
    func getMediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.string(from: self)
    }
    
    func getShortTime() -> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
