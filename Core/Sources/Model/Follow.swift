//
//  Follow.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Follow {
  public let followState: FollowState
  public let userId: String
  public let profileImage: String
  public let nickname: String
  public var isFollowing: Bool

  public init(
    followState: FollowState,
    userId: String,
    profileImage: String,
    nickname: String,
    isFollowing: Bool
  ) {
    self.followState = followState
    self.userId = userId
    self.profileImage = profileImage
    self.nickname = nickname
    self.isFollowing = isFollowing
  }
}

public enum FollowState {
  case following
  case follower
}
