//
//  DTO+GetPlaceRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPlaceRecordListRequest: Codable {
    public let placeId: Int
    public let cursorId: Int
    public let size: Int
    
    public init(
      placeId: Int,
      cursorId: Int,
      size: Int
    ) {
      self.placeId = placeId
      self.cursorId = cursorId
      self.size = size
    }
  }
}
