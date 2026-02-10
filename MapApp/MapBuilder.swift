//
//  MapBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


protocol MapBuilder {
    associatedtype MapView: MapPresenterToView
    func build() -> MapView
}
