//
//  Feed.swift
//  Core
//
//  Created by 한지석 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Feed: Equatable {
  public let id: Int
  public let userId: Int
  public let location: String
  public let placeInfo: PlaceInfo
  public let nickname: String
  public let description: String
  public var isBookmarked: Bool
  public var bookmarkCount: Int
  public let videoLink: String
  public let thumbnailLink: String
  public let isMine: Bool

  public init(
    id: Int,
    userId: Int,
    location: String,
    placeInfo: PlaceInfo,
    nickname: String,
    description: String,
    isBookmarked: Bool,
    bookmarkCount: Int,
    videoLink: String,
    thumbnailLink: String,
    isMine: Bool
  ) {
    self.id = id
    self.userId = userId
    self.location = location
    self.placeInfo = placeInfo
    self.nickname = nickname
    self.description = description
    self.isBookmarked = isBookmarked
    self.bookmarkCount = bookmarkCount
    self.videoLink = videoLink
    self.thumbnailLink = thumbnailLink
    self.isMine = isMine
  }
}
