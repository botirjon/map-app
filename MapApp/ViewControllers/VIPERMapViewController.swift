//
//  VIPERMapViewController.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//


import UIKit
import MapKit

class VIPERMapViewController: MapViewController {
    var presenter: MapViewToPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension VIPERMapViewController: MapPresenterToView {
    
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
