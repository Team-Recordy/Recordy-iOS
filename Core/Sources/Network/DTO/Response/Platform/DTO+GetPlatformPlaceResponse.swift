//
//  DTO+GetPlatformPlaceResponse.swift
//  Core
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPlatformPlaceResponse: Codable {
    public let platformPlaceId: String
    public let address: String
    public let longitude: Double
    public let latitude: Double
    public let name: String

    public init(
      platformPlaceId: String,
      address: String,
      longitude: Double,
      latitude: Double,
      name: String
    ) {
      self.platformPlaceId = platformPlaceId
      self.address = address
      self.longitude = longitude
      self.latitude = latitude
      self.name = name
    }
  }
}
