//
//  CoordinateEntity.swift
//  MapApp
//
//  Created by MAC-Nasridinov-B on 10/02/26.
//

import Foundation


public struct CoordinateEntity: Equatable {
    public let id: UUID
    public let latitude: Double
    public let longitude: Double
    public let title: String
    
    public init(id: UUID, latitude: Double, longitude: Double, title: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
    }
}
