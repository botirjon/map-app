//
//  MapPresenter.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import Foundation

class MapPresenter {
    weak var view: MapPresenterToView?
    var router: MapPresenterToRouter?
    var interactor: MapPresenterToInteractor?
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
        view?.displayCoordinates(coordinates)
    }
    
    func interactorDidFailLoading(with error: any Error) {
        view?.displayError(error.localizedDescription)
    }
}
