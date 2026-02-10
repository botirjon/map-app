//
//  LocalCoordinatesLoader.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

struct LocalCoordinateDTO: Decodable {
    let latitude: Double
    let longitude: Double
    let title: String
}

class LocalCoordinatesLoader: CoordinatesLoader {
    
    enum LocalCoordinatesLoaderError: Error {
        case invalidData
        case sourceNotFound
    }
    
    func load(completion: @escaping (CoordinatesLoader.Result) -> Void) {
        DispatchQueue.global().async {
            guard let fileURL = Bundle.main.url(forResource: "coordinates", withExtension: "json") else {
                completion(.failure(LocalCoordinatesLoaderError.sourceNotFound))
                return
            }
            
            do {
                let data = try Data.init(contentsOf: fileURL)
                let wrapper = try JSONDecoder().decode(CoordinatesWrapper.self, from: data)
                completion(.success(wrapper.coordinates.toEntities))
            } catch {
                completion(.failure(LocalCoordinatesLoaderError.invalidData))
            }
        }
    }
}

private struct CoordinatesWrapper: nonisolated Decodable {
    let coordinates: [LocalCoordinateDTO]
}

private extension Array where Element == LocalCoordinateDTO {
    var toEntities: [CoordinateEntity] {
        map {
            .init(
                id: UUID(),
                latitude: $0.latitude,
                longitude: $0.longitude,
                title: $0.title
            )
        }
    }
}
