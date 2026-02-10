//
//  MapViewController.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import MapKit

class MapViewController: UIViewController {
    typealias Coordinate = MKPointAnnotation
    
    private(set) lazy var activityIndicator = UIActivityIndicatorView()
    private(set) lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        centerMapCameraToUzbekistan()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(activityIndicator)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func centerMapCameraToUzbekistan() {
        let uzbekistanCenter = CLLocationCoordinate2D(latitude: 41.3775, longitude: 64.5853)
        let span = MKCoordinateSpan(latitudeDelta: 9.0, longitudeDelta: 14.0)
        let region = MKCoordinateRegion(center: uzbekistanCenter, span: span)
        mapView.setRegion(region, animated: true)
    }
}






