//
//  MapRouter.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


class MapRouter: MapPresenterToRouter {
    let router: any Router
    
    init(router: any Router) {
        self.router = router
    }
}