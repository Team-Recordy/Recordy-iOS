//
//  DTO+CreateExhibitionRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct CreateExhibitionRequest: BaseRequest {
    
    public let name: String
    public let startDate: String
    public let endDate: String
    public let isFree: Bool
    public let placeId: Int
    
    public init(
      name: String,
      startDate: String,
      endDate: String,
      isFree: Bool,
      placeId: Int
    ) {
      self.name = name
      self.startDate = startDate
      self.endDate = endDate
      self.isFree = isFree
      self.placeId = placeId
    }
  }
}
