//
//  DTO+FollowRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct FollowRequest: BaseRequest {
    /// 유저 ID
    let followingId: Int

    public init(followingId: Int) {
      self.followingId = followingId
    }
  }
}
