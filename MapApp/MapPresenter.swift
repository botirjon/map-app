//
//  MapPresenter.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import Foundation

class MapPresenter<Coordinate, MapView: MapPresenterToView> where MapView.Coordinate == Coordinate {
    weak var view: MapView?
    var router: MapPresenterToRouter?
    var interactor: MapPresenterToInteractor?
    var coordinateTransformer: (CoordinateEntity) -> Coordinate
    
    init(coordinateTransformer: @escaping (CoordinateEntity) -> Coordinate) {
        self.coordinateTransformer = coordinateTransformer
    }
}

extension MapPresenter: MapViewToPresenter {
    func viewDidLoad() {
        interactor?.loadCoordinates()
    }
    
    func viewRetryTapped() {
        interactor?.loadCoordinates()
    }
}

extension MapPresenter: MapInteractorToPresenter {
    func interactorDidBeginLoading() {
        view?.displayLoading(true)
    }
    
    func interactorDidFinishLoading() {
        view?.displayLoading(false)
    }
    
    func interactorDidSucceedLoading(_ coordinates: [CoordinateEntity]) {
        let viewModel = MapViewModel(coordinates: coordinates.map(coordinateTransformer))
        view?.displayCoordinates(viewModel)
    }
    
    func interactorDidFailLoading(with error: any Error) {
        view?.displayError(error.localizedDescription)
    }
}
