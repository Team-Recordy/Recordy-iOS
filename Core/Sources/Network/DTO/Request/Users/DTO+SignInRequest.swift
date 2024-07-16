//
//  DTO+SignInRequest.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct SignInRequest: BaseRequest {
    public let authorization: String
    public let platformType: PlatformType

    public init(
      authorization: String,
      platformType: PlatformType
    ) {
      self.authorization = authorization
      self.platformType = platformType
    }
  }
}

public enum PlatformType: String, Encodable {
  case apple = "APPLE"
  case kakao = "KAKAO"
}
