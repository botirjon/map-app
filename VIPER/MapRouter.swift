//
//  MapRouter.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


public class MapRouter: MapPresenterToRouter {
    let router: any Router
    
    public init(router: any Router) {
        self.router = router
    }
}
