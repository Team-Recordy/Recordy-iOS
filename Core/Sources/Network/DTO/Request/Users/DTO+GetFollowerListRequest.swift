//
//  DTO+GetFollowerListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFollowerListRequest: BaseRequest {
    let cursorId: Int?
    let size: Int
    
    public init(cursorId: Int?, size: Int) {
      self.cursorId = cursorId
      self.size = size
    }
    
    public var asQueryParameters: [String: Any] {
      var params: [String: Any] = ["size": size]
      if let cursorId = cursorId {
        params["cursorId"] = String(cursorId)
      }
      return params
    }
  }
}
