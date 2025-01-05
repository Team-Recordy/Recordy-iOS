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
    public let longitude: Int
    public let latitude: Int
    public let address: String
    
    public init(
      id: String,
      name: String,
      longitude: Int,
      latitude: Int,
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
