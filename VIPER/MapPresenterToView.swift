//
//  MapPresenterToView.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

public struct MapViewModel<Coordinate> {
    let coordinates: [Coordinate]
}

public protocol MapPresenterToView: AnyObject {
    associatedtype Coordinate
    func displayLoading(_ isLoading: Bool)
    func displayCoordinates(_ viewModel: MapViewModel<Coordinate>)
    func displayError(_ message: String)
}
