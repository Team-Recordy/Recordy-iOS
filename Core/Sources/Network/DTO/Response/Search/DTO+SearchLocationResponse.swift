//
//  DTO+SearchLocationResponse.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct SearchLocationResponse: BaseResponse {
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
