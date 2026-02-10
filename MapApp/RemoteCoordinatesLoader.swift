//
//  RemoteCoordinatesLoader.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

enum RemoteCoordinatesLoaderError: Error {
    case invalidateData
    case connectionError
}


enum NetworkError: Error {
    case connection
}

protocol NetworkService {
    func request(url: URL, completion: @escaping (Result<(data: Data, response: HTTPURLResponse), Error>) -> Void)
}

class LocalMockNetworkService: NetworkService {
    func request(url: URL, completion: @escaping (Result<(data: Data, response: HTTPURLResponse), any Error>) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [LocalMockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(NetworkError.connection))
            }
        }.resume()
    }
}

class RemoteCoordinatesLoader: CoordinatesLoader {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func load(completion: @escaping (CoordinatesLoader.Result) -> Void) {
        let url = URL(string: "https://api.example.com/coordinates")!
        networkService.request(url: url) { result in
            switch result {
            case .success(let (data, response)):
                do {
                    let coordinates = try Self.map(data: data, response: response)
                    completion(.success(coordinates))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func map(data: Data, response: HTTPURLResponse) throws -> [CoordinateEntity] {
        if response.statusCode != 200 {
            throw RemoteCoordinatesLoaderError.connectionError
        }
        
        do {
            let wrapper = try JSONDecoder().decode(RemoteCoordinatesWrapper.self, from: data)
            return wrapper.coordinates.map { dto in
                    .init(
                        id: UUID(),
                        latitude: dto.latitude,
                        longitude: dto.longitude,
                        title: dto.title
                    )
            }
        } catch {
            throw RemoteCoordinatesLoaderError.invalidateData
        }
    }
}

private struct RemoteCoordinatesWrapper: Decodable {
    let coordinates: [RemoteCoordinateDTO]
}

struct RemoteCoordinateDTO: Decodable {
    let latitude: Double
    let longitude: Double
    let title: String
}
