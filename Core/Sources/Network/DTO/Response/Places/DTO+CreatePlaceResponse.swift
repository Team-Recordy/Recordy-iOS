//
//  DTO+CreatePlaceResponse.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct CreatePlaceResponse: BaseRequest {
    
    public let placeId: Int
    
    public init(placeID: Int) {
      self.placeId = placeID
    }
  }
}
