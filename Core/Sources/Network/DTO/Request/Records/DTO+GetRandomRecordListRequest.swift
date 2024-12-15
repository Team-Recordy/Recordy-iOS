//
//  DTO+GetRandomRecordListRequest.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Foundation

extension DTO {
  public struct GetRandomRecordListRequest: BaseRequest {
    public let size: Int
    
    public init(
      size: Int
    ) {
      self.size = size
    }
  }
}
