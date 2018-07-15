//
//  AppConstant.swift
//  myTask
//
//  Created by Nghia Nguyen on 6/27/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class AppConstant {
    public static let EDIT_ACTION_BG_COLOR = UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1)
    public static let DONE_ACTION_BG_COLOR = UIColor(red: 0/225, green: 118/255, blue: 255/255, alpha: 1)
    public static let icons = ["allSchedule", "personalErrands", "workProjects", "groceryList", "other", "gift", "internet", "music-player", "paper-plane", "star"]
}

enum OrderType {
    case date
    case name
    
    func getString() -> String {
        switch self {
        case .date:
            return "createdAt"
        case .name:
            return "name"
        }
    }
}
