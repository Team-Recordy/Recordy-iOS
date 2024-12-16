//
//  DTO+EditExhibitionRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct EditExhibitionRequest: BaseRequest {
    
    public let id: Int
    public let name: String
    public let startDate: String
    public let endDate: String
    public let isFree: Bool
    
    public init(
      id: Int,
      name: String,
      startDate: String,
      endDate: String,
      isFree: Bool
    ) {
      self.id = id
      self.name = name
      self.startDate = startDate
      self.endDate = endDate
      self.isFree = isFree
    }
  }
}
