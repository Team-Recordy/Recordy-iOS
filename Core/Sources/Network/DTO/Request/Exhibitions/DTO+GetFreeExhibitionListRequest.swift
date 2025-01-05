//
//  DTO+GetFreeExhibitionListRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFreeExhibitionListRequest: BaseRequest {
    
    public let placeId: Int
    
    public init(
      placeId: Int
    ) {
      self.placeId = placeId
    }
  }
}

