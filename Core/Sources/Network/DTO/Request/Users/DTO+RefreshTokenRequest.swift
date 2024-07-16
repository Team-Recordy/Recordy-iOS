//
//  DTO+RefreshTokenRequest.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct RefreshTokenRequest: BaseRequest {
    let authorization: String

    public init(authorization: String) {
      self.authorization = authorization
    }
  }
}
