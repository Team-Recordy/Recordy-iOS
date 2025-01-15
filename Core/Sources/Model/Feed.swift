//
//  Feed.swift
//  Core
//
//  Created by 한지석 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Feed: Decodable {
  public let id: Int
  public let videoLink: String
  public let thumbnailLink: String
  public let description: String
  public let exhibitionName: String
  public let placeId: Int
  public let placeName: String
  public let uploaderId: Int
  public let uploaderNickname: String
  public var bookmarkCount: Int
  public let isMine: Bool
  public var isBookmarked: Bool
  
  public init(
    id: Int,
    videoLink: String,
    thumbnailLink: String,
    description: String,
    exhibitionName: String,
    placeId: Int,
    placeName: String,
    uploaderId: Int,
    uploaderNickname: String,
    bookmarkCount: Int,
    isMine: Bool,
    isBookmarked: Bool
  ) {
    self.id = id
    self.videoLink = videoLink
    self.thumbnailLink = thumbnailLink
    self.description = description
    self.exhibitionName = exhibitionName
    self.placeId = placeId
    self.placeName = placeName
    self.uploaderId = uploaderId
    self.uploaderNickname = uploaderNickname
    self.bookmarkCount = bookmarkCount
    self.isMine = isMine
    self.isBookmarked = isBookmarked
  }
}

extension Feed {
  public static let mockData: [Feed] = [
    Feed(
      id: 0,
      videoLink: "",
      thumbnailLink: "",
      description: "",
      exhibitionName: "",
      placeId: 1,
      placeName: "",
      uploaderId: 0,
      uploaderNickname: "",
      bookmarkCount: 0,
      isMine: false,
      isBookmarked: false
    ),
    Feed(
      id: 0,
      videoLink: "",
      thumbnailLink: "",
      description: "",
      exhibitionName: "",
      placeId: 1,
      placeName: "",
      uploaderId: 0,
      uploaderNickname: "",
      bookmarkCount: 0,
      isMine: false,
      isBookmarked: false
    ),
    Feed(
      id: 0,
      videoLink: "",
      thumbnailLink: "",
      description: "",
      exhibitionName: "",
      placeId: 1,
      placeName: "",
      uploaderId: 0,
      uploaderNickname: "",
      bookmarkCount: 0,
      isMine: false,
      isBookmarked: false
    ),
    Feed(
      id: 0,
      videoLink: "",
      thumbnailLink: "",
      description: "",
      exhibitionName: "",
      placeId: 1,
      placeName: "",
      uploaderId: 0,
      uploaderNickname: "",
      bookmarkCount: 0,
      isMine: false,
      isBookmarked: false
    ),
  ]
}
