//
//  DTO+GetFollowingRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFollowingRecordListRequest: BaseRequest {
    /// 페이지네이션을 위함
    public let cursorId: Int
    /// 페이지당 항목 수
    public let size: Int

    public init(
      cursorId: Int,
      size: Int
    ) {
      self.cursorId = cursorId
      self.size = size
    }
  }
}
