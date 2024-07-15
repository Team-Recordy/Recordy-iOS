//
//  FeedModel.swift
//  Core
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

public struct FeedModel {
  public let id: Int
  public let thumbnail: String
  public let isbookmarked: Bool
  public let location: String
  public let video: String?
  public let keywords: [Keyword]
  public let nickname: String?
  public let description: String?
  public let bookmarkCount: Int?
  
  public init(id: Int, thumbnail: String, isbookmarked: Bool, location: String, video: String?, keywords: [Keyword], nickname: String?, description: String?, bookmarkCount: Int?) {
    self.id = id
    self.thumbnail = thumbnail
    self.isbookmarked = isbookmarked
    self.location = location
    self.video = video
    self.keywords = keywords
    self.nickname = nickname
    self.description = description
    self.bookmarkCount = bookmarkCount
  }
}
