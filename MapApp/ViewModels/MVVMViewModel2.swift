//
//  MVVMViewModel2.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//


import Foundation
import MapKit

protocol MVVMViewModel2 {
    associatedtype Coordinate
    var coordinates: [Coordinate] { get }
    func loadCoordinates()
}

class MapMVVMViewModel2<Coordinate>: MVVMViewModel2 {
    typealias Coordinate = Coordinate
    
    var coordinates: [Coordinate] = []
    var onCoordinatesChanged: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChange: ((Bool) -> Void)?
    
    private let loader: CoordinatesLoader
    private let coordinateTransformer: (CoordinateEntity) -> Coordinate
    
    init(loader: CoordinatesLoader, coordinateTransformer: @escaping (CoordinateEntity) -> Coordinate) {
        self.loader = loader
        self.coordinateTransformer = coordinateTransformer
    }
    
    func loadCoordinates() {
        onLoadingChange?(true)
        loader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entities):
                coordinates = entities.map(coordinateTransformer)
                onCoordinatesChanged?()
                
            case .failure(let error):
                onError?(error.localizedDescription)
            }
            onLoadingChange?(false)
        }
    }
}

class MapMVVMViewModel2Adapter: MVVMViewModel2, MVVM2MapViewInput {
    typealias Coordinate = MKPointAnnotation
    
    let viewModel: MapMVVMViewModel2<MKPointAnnotation>
    weak var view: MVVM2MapViewController?
    
    init(viewModel: MapMVVMViewModel2<MKPointAnnotation>) {
        self.viewModel = viewModel
        setupBindings()
    }

    var coordinates: [Coordinate] { viewModel.coordinates }
    
    func loadCoordinates() {
        viewModel.loadCoordinates()
    }
    
    private func setupBindings() {
        viewModel.onCoordinatesChanged = { [weak self] in
            guard let self else { return }
            view?.displayCoordinates(.init(coordinates: coordinates))
        }
        
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            view?.displayError(error)
        }
        
        viewModel.onLoadingChange = { [weak self] isLoading in
            guard let self else { return }
            view?.displayLoading(isLoading)
        }
    }
}
