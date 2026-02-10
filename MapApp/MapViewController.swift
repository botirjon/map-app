//
//  MapViewController.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import MapKit
import UIKit

class MapViewController: UIViewController {
    typealias Coordinate = MKPointAnnotation
    var presenter: MapViewToPresenter?
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        centerMapCameraToUzbekistan()
        presenter?.viewDidLoad()
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

extension MapViewController: MapPresenterToView {
    
    func displayLoading(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func displayCoordinates(_ viewModel: MapViewModel<MKPointAnnotation>) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.coordinates)
    }
    
    func displayError(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.presenter?.viewRetryTapped()
        }
        errorAlert.addAction(retryAction)
        errorAlert.addAction(.init(title: "Cancel", style: .cancel))
        
        present(errorAlert, animated: true)
    }
}
