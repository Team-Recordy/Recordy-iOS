//
//  DTO+GetFreeExhibitionResponse.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFreeExhibitionResponse: BaseRequest {
    
    public let id: Int
    public let name: String
    public let startDate: String
    public let isFree: Bool
    
    public init(
      id: Int,
      name: String,
      startDate: String,
      isFree: Bool
    ) {
      self.id = id
      self.name = name
      self.startDate = startDate
      self.isFree = isFree
    }
  }
}
