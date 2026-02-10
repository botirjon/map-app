//
//  MapPresenterToView.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


protocol MapPresenterToView: AnyObject {
    func displayLoading(_ isLoading: Bool)
    func displayCoordinates(_ coordinates: [CoordinateEntity])
    func displayError(_ message: String)
}