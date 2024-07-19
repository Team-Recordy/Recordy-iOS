//
//  ProfileUserModel.swift
//  Core
//
//  Created by 한지석 on 7/20/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct ProfileUserModel {
  public let name: String
  public let followerCount: String
  public let followingCount: String

  public init(
    name: String,
    followerCount: String,
    followingCount: String
  ) {
    self.name = name
    self.followerCount = followerCount
    self.followingCount = followingCount
  }
}
