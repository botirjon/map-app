//
//  NetworkService.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation

protocol NetworkService {
    func request(url: URL, completion: @escaping (Result<(data: Data, response: HTTPURLResponse), Error>) -> Void)
}
