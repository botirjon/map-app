//
//  NetworkError.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

enum NetworkError: Error {
    case connection
}

class LocalMockNetworkService: NetworkService {
    func request(url: URL, completion: @escaping (Result<(data: Data, response: HTTPURLResponse), any Error>) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [LocalMockURLProtocol.self]
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
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
