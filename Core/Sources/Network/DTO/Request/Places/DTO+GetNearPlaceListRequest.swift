//
//  DTO+GetNearPlaceListRequest.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetNearPlaceListRequest: BaseRequest {
    public let number: Int
    public let size: Int
    public let latitude: Double
    public let longitude: Double
    public let distance: Double
    
    public init(
      number: Int,
      size: Int,
      latitude: Double,
      longitude: Double,
      distance: Double
    ) {
      self.number = number
      self.size = size
      self.latitude = latitude
      self.longitude = longitude
      self.distance = distance
    }
  }
}
