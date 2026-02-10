//
//  MVVMViewModel.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

protocol MVVMViewModel {
    associatedtype Coordinate
    var coordinates: [Coordinate] { get }
    var onCoordinatesChanged: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingChange: ((Bool) -> Void)? { get set }
    func loadCoordinates()
}

class MapMVVMViewModel<Coordinate>: MVVMViewModel {
    
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
