//
//  Place.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Place: Decodable {
    public let id: Int
    public let name: String
    public let address: String
    public let platformId: String
    public let locationId: Int
    public let longitude: Double
    public let latitude: Double
    public let exhibitionSize: Int
    public let recordSize: Int

    public init(
        id: Int,
        name: String,
        address: String,
        platformId: String,
        locationId: Int,
        longitude: Double,
        latitude: Double,
        exhibitionSize: Int,
        recordSize: Int
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.platformId = platformId
        self.locationId = locationId
        self.longitude = longitude
        self.latitude = latitude
        self.exhibitionSize = exhibitionSize
        self.recordSize = recordSize
    }
}
