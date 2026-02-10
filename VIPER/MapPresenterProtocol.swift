//
//  MapPresenterToInteractor.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

public protocol MapViewToPresenter: AnyObject {
    func viewDidLoad()
    func viewRetryTapped()
}

public protocol MapInteractorToPresenter: AnyObject {
    func interactorDidBeginLoading()
    func interactorDidFinishLoading()
    func interactorDidSucceedLoading(_ coordinates: [CoordinateEntity])
    func interactorDidFailLoading(with error: Error)
}
