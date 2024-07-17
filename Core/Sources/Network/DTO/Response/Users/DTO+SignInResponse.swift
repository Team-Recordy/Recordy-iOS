//
//  DTO+SignInResponse.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct SignInResponse: BaseResponse {
    public let userId: Int
    public let accessToken: String
    public let refreshToken: String
    public let isSignedUp: Bool

    public init(
      userId: Int,
      accessToken: String,
      refreshToken: String,
      isSignedUp: Bool
    ) {
      self.userId = userId
      self.accessToken = accessToken
      self.refreshToken = refreshToken
      self.isSignedUp = isSignedUp
    }
  }
}
