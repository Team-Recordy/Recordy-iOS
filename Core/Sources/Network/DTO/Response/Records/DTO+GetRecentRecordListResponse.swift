//
//  DTO+GetRecentRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetRecentRecordListResponse: BaseResponse {
    public let nextCursor: Int
    public let hasNext: Bool
    public let content: [Content]

    public init(
      nextCursor: Int,
      hasNext: Bool,
      content: [Content]
    ) {
      self.nextCursor = nextCursor
      self.hasNext = hasNext
      self.content = content
    }
  }
}

extension DTO.GetRecentRecordListResponse {
  public struct Content: BaseResponse {
    public let recordInfo: RecordInfo
    public let isBookmark: Bool

    public init(
      recordInfo: RecordInfo,
      isBookmark: Bool
    ) {
      self.recordInfo = recordInfo
      self.isBookmark = isBookmark
    }
  }
}

extension DTO.GetRecentRecordListResponse.Content {
  public struct RecordInfo: BaseResponse {
    public let id: Int
    public let fileUrl: FileUrl
    public let location: String
    public let content: String
    public let uploaderId: Int
    public let uploaderNickname: String
    public let bookmarkCount: Int
    public let isMine: Bool
  }
}

extension DTO.GetRecentRecordListResponse.Content.RecordInfo {
  public struct FileUrl: BaseResponse {
    public let videoUrl: String
    public let thumbnailUrl: String

    init(
      videoUrl: String,
      thumbnailUrl: String
    ) {
      self.videoUrl = videoUrl
      self.thumbnailUrl = thumbnailUrl
    }
  }
}

extension DTO.GetRecentRecordListResponse {
  public var feeds: [Feed] {
    return content.map {
      Feed(
        id: $0.recordInfo.id,
        userId: $0.recordInfo.uploaderId,
        location: $0.recordInfo.location,
        placeInfo: PlaceInfo(
          feature: .all,
          title: "국현미",
          duration: "2024.10.03~"
        ),
        nickname: $0.recordInfo.uploaderNickname,
        description: $0.recordInfo.content,
        isBookmarked: $0.isBookmark,
        bookmarkCount: $0.recordInfo.bookmarkCount,
        videoLink: $0.recordInfo.fileUrl.videoUrl,
        thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl,
        isMine: $0.recordInfo.isMine
      )
    }
  }
}

