//
//  DTO+GetFollowingListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFollowingListRequest: BaseRequest {
    /// 페이지네이션 커서 ID (옵셔널)
    let cursorId: Int?
    /// 가져올 데이터 갯수
    let size: Int
    
    public init(cursorId: Int?, size: Int) {
      self.cursorId = cursorId
      self.size = size
    }
    
    public var asQueryParameters: [String: Any] {
      var params: [String: Any] = ["size": size]
      if let cursorId = cursorId {
        params["cursorId"] = cursorId
      }
      return params
    }
  }
}
