//
//  LocalSourcedMapBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import UIKit

class LocalSourcedMapBuilder: MapBuilder {
    func build() -> MapViewController {
        let service = CoordinatesLoaderMainQueueDecorator(target: LocalCoordinatesLoader())
        
        let viewController = MapViewController()
        let presenter = MapPresenter()
        let interactor = MapInteractor(loader: service)
        let router = MapRouter(router: viewController)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
}
