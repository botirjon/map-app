//
//  MVVM2MapViewController.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//

import MapKit

protocol MVVM2MapViewInput {
    func loadCoordinates()
}

class MVVM2MapViewController: MapViewController {
    var input: MVVM2MapViewInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input?.loadCoordinates()
    }
}

extension MVVM2MapViewController {
    
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
            self?.input?.loadCoordinates()
        }
        errorAlert.addAction(retryAction)
        errorAlert.addAction(.init(title: "Cancel", style: .cancel))
        
        present(errorAlert, animated: true)
    }
}
