//
//  NewTaskControllerDelegate.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/3/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import Foundation

protocol NewTaskViewControllerDelegate: class {
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingAdding item: Task)
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingEditing item: Task)
}
