//
//  UIKitMapRemoteBuilderWithMVVM2.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//

import MapKit

class UIKitMapRemoteBuilderWithMVVM2: UIKitMapBuilder {
    typealias MapView = MapViewController
    
    func build() -> MapViewController {
        let loader = RemoteCoordinatesLoader(networkService: LocalMockNetworkService())
        let decoratedLoader = CoordinatesLoaderMainQueueDecorator(target: loader)
        let viewModel = MapMVVMViewModel2<MKPointAnnotation>(
            loader: decoratedLoader,
            coordinateTransformer: transform(_:)
        )
        let viewController = MVVM2MapViewController()
        let adapter = MapMVVMViewModel2Adapter(viewModel: viewModel)
        adapter.view = viewController
        viewController.input = adapter
        
        return viewController
    }
}
