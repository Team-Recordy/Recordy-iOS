//
//  User.swift
//  Core
//
//  Created by 한지석 on 7/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct User {
  public let isMine: Bool
  public let id: Int
  public let nickname: String
  public let follower: [Follow]
  public let following: [Follow]?
  public var isFollowing: Bool
  public let profileImage: String
  public let feeds: [Feed]
  public let bookmarkedFeeds: [Feed]?
  public let loginState: LoginState

  public init(
    isMine: Bool,
    id: Int,
    nickname: String,
    follower: [Follow],
    following: [Follow]?,
    isFollowing: Bool,
    profileImage: String,
    feeds: [Feed],
    bookmarkedFeeds: [Feed]?,
    loginState: LoginState
  ) {
    self.isMine = isMine
    self.id = id
    self.nickname = nickname
    self.follower = follower
    self.following = following
    self.isFollowing = isFollowing
    self.profileImage = profileImage
    self.feeds = feeds
    self.bookmarkedFeeds = bookmarkedFeeds
    self.loginState = loginState
  }
}

public enum LoginState {
  case apple
  case kakao
}
