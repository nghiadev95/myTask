//
//  MapViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/11/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {

    let locationManager = CLLocationManager()
    var selectedLocation: CLLocation?
    var currentLocation: CLLocation?
    var mapView: MKMapView!
    var resultSearchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = SearchLocationTableViewController()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
    }

    override func loadView() {
        super.loadView()
        mapView = MKMapView()
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.snp.makeConstraints { (m) in
            m.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func centerMapWithLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let location = currentLocation {
            centerMapWithLocation(location: location)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        currentLocation = lastLocation
        centerMapWithLocation(location: lastLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
