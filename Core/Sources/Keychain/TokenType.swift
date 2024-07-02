//
//  TokenType.swift
//  Core
//
//  Created by 한지석 on 7/2/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public enum TokenType {
  case AccessToken
  case RefreshToken
  
  public var account: String {
    switch self {
    case .AccessToken:
      "accessToken"
    case .RefreshToken:
      "refreshToken"
    }
  }
}
