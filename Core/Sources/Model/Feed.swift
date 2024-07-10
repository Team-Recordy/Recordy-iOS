//
//  Feed.swift
//  Core
//
//  Created by 한지석 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Feed {
  public let id: Int
  public let location: String
  public let nickname: String
  public let description: String
  public let bookmarkCount: String
  public var isBookmarked: Bool
  public let videoLink: URL

  public init(
    id: Int,
    location: String,
    nickname: String,
    description: String,
    bookmarkCount: String,
    isBookmarked: Bool,
    videoLink: URL
  ) {
    self.id = id
    self.location = location
    self.nickname = nickname
    self.description = description
    self.bookmarkCount = bookmarkCount
    self.isBookmarked = isBookmarked
    self.videoLink = videoLink
  }
}

extension Feed {
  public static let mockdata: [Feed] = [
    Feed(
      id: 0,
      location: "서울특별시 강남구",
      nickname: "닉네임",
      description: "0번 영상",
      bookmarkCount: "100",
      isBookmarked: true,
      videoLink: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!
    ),
    Feed(
      id: 1,
      location: "서울특별시 강남구",
      nickname: "닉네임",
      description: "1번 영상",
      bookmarkCount: "8",
      isBookmarked: false,
      videoLink: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")!
    ),
    Feed(
      id: 2,
      location: "서울특별시 강남구",
      nickname: "닉네임",
      description: "2번 영상",
      bookmarkCount: "110",
      isBookmarked: false,
      videoLink: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")!
    )]
}