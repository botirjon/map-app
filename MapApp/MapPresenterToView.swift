//
//  MapPresenterToView.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

struct MapViewModel<Coordinate> {
    let coordinates: [Coordinate]
}

protocol MapPresenterToView: AnyObject {
    associatedtype Coordinate
    func displayLoading(_ isLoading: Bool)
    func displayCoordinates(_ viewModel: MapViewModel<Coordinate>)
    func displayError(_ message: String)
}
