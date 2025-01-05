//
//  DTO+GetSearchResponse.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetSearchResponse: BaseResponse {
    public let id: Int
    public let type: String
    public let address: String
    public let name: String
    
    public init(
      id: Int,
      type: String,
      address: String,
      name: String
    ) {
      self.id = id
      self.type = type
      self.address = address
      self.name = name
    }
  }
}
