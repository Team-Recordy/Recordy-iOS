//
//  Follower.swift
//  Core
//
//  Created by 한지석 on 7/20/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Follower {
  public let id: Int
  public let username: String
  public var isFollowing: Bool
  public let profileImage : String

  public init(
    id: Int,
    username: String,
    isFollowing: Bool,
    profileImage: String
  ) {
    self.id = id
    self.username = username
    self.isFollowing = isFollowing
    self.profileImage = profileImage
  }
}
