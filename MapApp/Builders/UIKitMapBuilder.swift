//
//  UIKitMapBuilder.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 11/02/26.
//

import MapKit

protocol UIKitMapBuilder {
    associatedtype MapView: UIViewController
    func build() -> MapView
}

extension UIKitMapBuilder {
    func transform(_ coordinate: CoordinateEntity) -> MKPointAnnotation {
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let annotation = MKPointAnnotation(coordinate: location)
        annotation.title = coordinate.title
        return annotation
    }
}
