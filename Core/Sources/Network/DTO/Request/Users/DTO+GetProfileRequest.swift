//
//  DTO+GetProfileRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetProfileRequest: BaseRequest {
    /// 유저의 프로필 ID, 본인 포함
    public let otherUserId: Int

    public init(otherUserId: Int) {
      self.otherUserId = otherUserId
    }
  }
}
