//
//  UIKitMapRemoteBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


import UIKit
import MapKit


class UIKitMapRemoteBuilder: MapBuilder {
    typealias MapView = MapViewController
    
    func build() -> MapViewController {
        let networkService = LocalMockNetworkService()
        let service = CoordinatesLoaderMainQueueDecorator(target: RemoteCoordinatesLoader(networkService: networkService))
        
        let viewController = MapViewController()
        let presenter = MapPresenter<MKPointAnnotation, MapViewController>(coordinateTransformer: transform(_:))
        let interactor = MapInteractor(loader: service)
        let router = MapRouter(router: viewController)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
    
    private func transform(_ coordinate: CoordinateEntity) -> MKPointAnnotation {
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let annotation = MKPointAnnotation(coordinate: location)
        annotation.title = coordinate.title
        return annotation
    }
}
