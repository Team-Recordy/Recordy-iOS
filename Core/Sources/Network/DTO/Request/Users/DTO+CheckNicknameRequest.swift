//
//  DTO+CheckNicknameRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct CheckNicknameRequest: BaseRequest {
    public let nickname: String

    public init(nickname: String) {
      self.nickname = nickname
    }
  }
}
