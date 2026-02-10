//
//  CoordinatesLoader.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//


public protocol CoordinatesLoader {
    typealias Result = Swift.Result<[CoordinateEntity], Error>
    func load(completion: @escaping (Result) -> Void)
}
