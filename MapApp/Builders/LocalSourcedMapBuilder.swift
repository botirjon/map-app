//
//  LocalSourcedMapBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import MapKit

class UIKitMapLocalBuilder: UIKitMapBuilder {
    typealias MapView = MapViewController
    
    func build() -> MapViewController {
        let service = CoordinatesLoaderMainQueueDecorator(target: LocalCoordinatesLoader())
        
        let viewController = VIPERMapViewController()
        let presenter = MapPresenter<MKPointAnnotation, VIPERMapViewController>(coordinateTransformer: transform(_:))
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



