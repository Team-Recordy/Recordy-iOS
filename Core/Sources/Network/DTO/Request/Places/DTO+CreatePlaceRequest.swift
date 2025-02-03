//
//  DTO+CreatePlaceRequest.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Foundation

extension DTO {
  public struct CreatePlaceRequest: BaseRequest {
    
    public let id: String
    public let name: String
    public let longitude: Double
    public let latitude: Double
    public let address: String
    
    public init(
      id: String,
      name: String,
      longitude: Double,
      latitude: Double,
      address: String
    ) {
      self.id = id
      self.name = name
      self.longitude = longitude
      self.latitude = latitude
      self.address = address
    }
  }
}
