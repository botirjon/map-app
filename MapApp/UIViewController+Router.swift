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
    typealias Route = UIViewController
    
    func push(_ route: UIViewController) {
        navigationController?.pushViewController(route, animated: true)
    }
    
    func dismiss(_ route: UIViewController) {
        route.dismiss(animated: true)
    }
    
    func present(_ route: UIViewController) {
        present(route, animated: true)
    }
}
