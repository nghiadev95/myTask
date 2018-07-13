//
//  NewTaskControllerDelegate.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/3/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import MapKit

protocol NewTaskViewControllerDelegate: class {
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingAdding item: Task)
    func newTaskViewController(_ controller: NewTaskViewController, didFinishingEditing item: Task)
}

protocol HandleMapSearchDelegate {
    func dropPinZoomIn(placemark: MKPlacemark)
}

protocol MapViewControllerDelegate: class {
    func mapViewController(_ controller: MapViewController, didSelectedLocation location: MKPlacemark)
}

