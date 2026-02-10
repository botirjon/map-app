//
//  MVVMMapViewController.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//

import MapKit

class MVVMMapViewController<ViewModel: MVVMViewModel>: MapViewController where ViewModel.Coordinate == MKPointAnnotation {
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel?.loadCoordinates()
    }
    
    private func setupBindings() {
        viewModel?.onCoordinatesChanged = { [weak self] in
            guard let self else { return }
            displayCoordinates(.init(coordinates: viewModel?.coordinates ?? []))
        }
        
        viewModel?.onError = { [weak self] error in
            guard let self else { return }
            displayError(error)
        }
        
        viewModel?.onLoadingChange = { [weak self] isLoading in
            guard let self else { return }
            displayLoading(isLoading)
        }
    }
}

extension MVVMMapViewController {
    
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
            self?.viewModel?.loadCoordinates()
        }
        errorAlert.addAction(retryAction)
        errorAlert.addAction(.init(title: "Cancel", style: .cancel))
        
        present(errorAlert, animated: true)
    }
}
