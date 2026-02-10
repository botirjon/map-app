//
//  CoordinatesLoaderMainQueueDecorator.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//
import Foundation

class CoordinatesLoaderMainQueueDecorator: CoordinatesLoader {
    private let target: CoordinatesLoader
    
    init(target: CoordinatesLoader) {
        self.target = target
    }
    
    func load(completion: @escaping (CoordinatesLoader.Result) -> Void) {
        target.load { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
