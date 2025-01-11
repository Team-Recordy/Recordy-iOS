//
//  DTO+GetPlaceResponse.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPlaceResponse: Codable {
    
    public let id: Int
    public let name: String
    public let address: String
    public let platformId: String
    public let location: Location
    public let exhibitionSize: Int
    public let recordSize: Int
    
    public init(
      id: Int,
      name: String,
      address: String,
      platformId: String,
      location: Location,
      exhibitionSize: Int,
      recordSize: Int
    ) {
      self.id = id
      self.name = name
      self.address = address
      self.platformId = platformId
      self.location = location
      self.exhibitionSize = exhibitionSize
      self.recordSize = recordSize
    }
  }
}

extension DTO.GetPlaceResponse {
  public struct Location: BaseResponse {
    public let id: Int
    public let longitude: Double
    public let latitude: Double
    
    public init(
      id: Int,
      longitude: Double,
      latitude: Double
    ) {
      self.id = id
      self.longitude = longitude
      self.latitude = latitude
    }
  }
}
