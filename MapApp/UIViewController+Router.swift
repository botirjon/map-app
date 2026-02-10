//
//  UIViewController+Router.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import UIKit

extension UIViewController: Routable {
    
}

extension UIViewController: Router {
    public typealias Route = UIViewController
    
    public func push(_ route: UIViewController) {
        navigationController?.pushViewController(route, animated: true)
    }
    
    public func dismiss(_ route: UIViewController) {
        route.dismiss(animated: true)
    }
    
    public func present(_ route: UIViewController) {
        present(route, animated: true)
    }
}
