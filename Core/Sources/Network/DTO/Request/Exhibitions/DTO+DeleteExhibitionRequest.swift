//
//  DTO+DeleteExhibitionRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct DeleteExhibitionRequest: BaseRequest {
    
    public let exhibitionId: Int
    
    public init(
      exhibitionId: Int
    ) {
      self.exhibitionId = exhibitionId
    }
  }
}
