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
    var selectedPin: MKPlacemark? = nil
    weak var delegate: MapViewControllerDelegate? = nil
    
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
        locationSearchTable.handleMapSearchDelegate = self
        mapView.delegate = self
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
        let span = MKCoordinateSpanMake(0.005, 0.005)
        var region: MKCoordinateRegion
        if selectedLocation != nil {
            region = MKCoordinateRegion(center: selectedLocation!.coordinate, span: span)
        } else {
            region = MKCoordinateRegion(center: location.coordinate, span: span)
        }
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedLocation != nil {
            let seletedPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude))
            dropPinZoomIn(placemark: seletedPlaceMark)
//            centerMapWithLocation(location: selectedLocation!)
        } else if let location = currentLocation {
            centerMapWithLocation(location: location)
        }
    }
    
    @objc func selectLocation(){
        if let selectedPin = selectedPin {
            delegate?.mapViewController(self, didSelectedLocation: selectedPin)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

extension MapViewController: HandleMapSearchDelegate {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
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