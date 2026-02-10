//
//  MapPresenter.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import Foundation

public class MapPresenter<Coordinate, MapView: MapPresenterToView> where MapView.Coordinate == Coordinate {
    public weak var view: MapView?
    public var router: MapPresenterToRouter?
    public var interactor: MapPresenterToInteractor?
    var coordinateTransformer: (CoordinateEntity) -> Coordinate
    
    public init(coordinateTransformer: @escaping (CoordinateEntity) -> Coordinate) {
        self.coordinateTransformer = coordinateTransformer
    }
}

extension MapPresenter: MapViewToPresenter {
    public func viewDidLoad() {
        interactor?.loadCoordinates()
    }
    
    public func viewRetryTapped() {
        interactor?.loadCoordinates()
    }
}

extension MapPresenter: MapInteractorToPresenter {
    public func interactorDidBeginLoading() {
        view?.displayLoading(true)
    }
    
    public func interactorDidFinishLoading() {
        view?.displayLoading(false)
    }
    
    public func interactorDidSucceedLoading(_ coordinates: [CoordinateEntity]) {
        let viewModel = MapViewModel(coordinates: coordinates.map(coordinateTransformer))
        view?.displayCoordinates(viewModel)
    }
    
    public func interactorDidFailLoading(with error: any Error) {
        view?.displayError(error.localizedDescription)
    }
}
