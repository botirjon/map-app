//
//  MapInteractor.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


class MapInteractor: MapPresenterToInteractor {
    weak var presenter: MapInteractorToPresenter?
    
    let loader: CoordinatesLoader
    
    init(loader: CoordinatesLoader) {
        self.loader = loader
    }
    
    func loadCoordinates() {
        presenter?.interactorDidBeginLoading()
        loader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let coordinates):
                presenter?.interactorDidSucceedLoading(coordinates)
            case .failure(let error):
                presenter?.interactorDidFailLoading(with: error)
            }
            presenter?.interactorDidFinishLoading()
        }
    }
}