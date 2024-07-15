//
//  SignIn.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct SignIn {
  public let accessToken: String
  public let refreshToken: String
  public let isSignedIn: Bool

  public init(
    accessToken: String,
    refreshToken: String,
    isSignedIn: Bool
  ) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.isSignedIn = isSignedIn
  }
}
