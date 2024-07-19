//
//  User.swift
//  Core
//
//  Created by 한지석 on 7/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct User {
  public let id: Int
  public let nickname: String
  public let followerCount: Int
  public var isFollowing: Bool
  public let profileImage: String

  public init(
    id: Int,
    nickname: String,
    followerCount: Int,
    isFollowing: Bool,
    profileImage: String
  ) {
    self.id = id
    self.nickname = nickname
    self.followerCount = followerCount
    self.isFollowing = isFollowing
    self.profileImage = profileImage
  }
}
