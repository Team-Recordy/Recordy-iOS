//
//  DTO+GetUserRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetUserRecordListRequest: BaseRequest {
    public let otherUserId: Int
    public let cursorId: Int
    public let size: Int

    public init(
      otherUserId: Int,
      cursorId: Int,
      size: Int
    ) {
      self.otherUserId = otherUserId
      self.cursorId = cursorId
      self.size = size
    }
  }
}
