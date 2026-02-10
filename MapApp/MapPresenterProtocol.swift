//
//  MapPresenterToInteractor.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

protocol MapViewToPresenter: AnyObject {
    func viewDidLoad()
    func viewRetryTapped()
}

protocol MapInteractorToPresenter: AnyObject {
    func interactorDidBeginLoading()
    func interactorDidFinishLoading()
    func interactorDidSucceedLoading(_ coordinates: [CoordinateEntity])
    func interactorDidFailLoading(with error: Error)
}
