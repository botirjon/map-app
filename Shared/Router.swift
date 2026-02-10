//
//  Routable.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


public protocol Routable {}

public protocol Router {
    associatedtype Route: Routable
    func push(_ route: Route)
    func dismiss(_ route: Route)
    func present(_ route: Route)
}
