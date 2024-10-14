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
  public var feeds: [Feed]
  public var bookmarkedFeeds: [Feed]?
  public let loginState: LoginState
  
  public let recordCount: Int
  public let followerCount: Int
  public let followingCount: Int
  public let bookmarkCount: Int

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
    loginState: LoginState,
    recordCount: Int,
    followerCount: Int,
    followingCount: Int,
    bookmarkCount: Int
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
    self.recordCount = recordCount
    self.followerCount = followerCount
    self.followingCount = followingCount
    self.bookmarkCount = bookmarkCount
  }
}

public enum LoginState {
  case apple
  case kakao
}
