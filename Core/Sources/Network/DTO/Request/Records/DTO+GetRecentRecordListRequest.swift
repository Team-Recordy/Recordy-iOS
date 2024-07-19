//
//  DTO+GetRecentRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetRecentRecordListRequest: BaseRequest {
    public let keywords: String?
    public let cursorId: Int
    public let size: Int

    public init(
      keywords: String?,
      cursorId: Int,
      size: Int
    ) {
      self.keywords = keywords
      self.cursorId = cursorId
      self.size = size
    }
  }
}
