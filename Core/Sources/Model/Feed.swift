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
  public var bookmarkCount: Int
  public var isBookmarked: Bool
  public let videoLink: URL

  public init(
    id: Int,
    location: String,
    nickname: String,
    description: String,
    bookmarkCount: Int,
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
      bookmarkCount: 0,
      isBookmarked: true,
      videoLink: URL(string: "https://recordy-bucket.s3.ap-northeast-2.amazonaws.com/videos/IMG_81.mov")!
    ),
    Feed(
      id: 1,
      location: "서울특별시 강남구",
      nickname: "닉네임",
      description: "1번영상https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
      bookmarkCount: 0,
      isBookmarked: false,
      videoLink: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")!
    ),
    Feed(
      id: 2,
      location: "서울특별시 강남구",
      nickname: "닉네임",
      description: "2번 영상",
      bookmarkCount: 0,
      isBookmarked: false,
      videoLink: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")!
    )]
  
  public static let mockdata1: [Feed] = [
    Feed(
      id: 3,
      location: "",
      nickname: "",
      description: "",
      bookmarkCount: 0,
      isBookmarked: false,
      videoLink: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-palm-tree-in-front-of-the-sun-1191-large.mp4")!
    ),
    Feed(
      id: 4,
      location: "",
      nickname: "",
      description: "",
      bookmarkCount: 0,
      isBookmarked: false,
      videoLink: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-red-frog-on-a-log-1487-large.mp4")!
    ),
    Feed(
      id: 5,
      location: "",
      nickname: "",
      description: "",
      bookmarkCount: 0,
      isBookmarked: false,
      videoLink: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4")!
    )
  ]

}
