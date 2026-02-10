//
//  UIKitMapRemoteBuilderWithMVVM.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//

import MapKit

class UIKitMapRemoteBuilderWithMVVM: UIKitMapBuilder {
    typealias MapView = MapViewController
    func build() -> MapViewController {
        let loader = RemoteCoordinatesLoader(networkService: LocalMockNetworkService())
        let decoratedLoader = CoordinatesLoaderMainQueueDecorator(target: loader)
        let viewModel = MapMVVMViewModel<MKPointAnnotation>(
            loader: decoratedLoader,
            coordinateTransformer: transform(_:)
        )
        
        let viewController = MVVMMapViewController<MapMVVMViewModel<MKPointAnnotation>>()
        viewController.viewModel = viewModel
        return viewController
    }
}
