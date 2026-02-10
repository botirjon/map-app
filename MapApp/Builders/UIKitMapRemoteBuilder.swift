//
//  UIKitMapRemoteBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import UIKit
import MapKit


class UIKitMapRemoteBuilder: UIKitMapBuilder {
    typealias MapView = MapViewController
    
    func build() -> MapViewController {
        let networkService = LocalMockNetworkService()
        let service = CoordinatesLoaderMainQueueDecorator(target: RemoteCoordinatesLoader(networkService: networkService))
        
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
