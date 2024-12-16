//
//  DTO+GetOngoingExhibitionPlacesRequest.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetOngoingExhibitionPlacesRequest: BaseResponse {
    public let number: Int
    public let size: Int
    
    public init(
      number: Int,
      size: Int
    ) {
      self.number = number
      self.size = size
    }
  }
}
