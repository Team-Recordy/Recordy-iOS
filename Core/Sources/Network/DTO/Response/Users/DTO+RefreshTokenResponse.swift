//
//  DTO+RefreshTokenResponse.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct RefreshTokenResponse: BaseResponse {
    public let accessToken: String

    public init(accessToken: String) {
      self.accessToken = accessToken
    }
  }
}
