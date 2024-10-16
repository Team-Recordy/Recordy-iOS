//
//  DTO+GetUserRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetUserRecordListResponse: BaseResponse {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let content: [Content]
  }
}

extension DTO.GetUserRecordListResponse {
  public struct Content: BaseResponse {
    public let recordInfo: RecordInfo
    public let isBookmark: Bool
  }
}

extension DTO.GetUserRecordListResponse.Content {
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

extension DTO.GetUserRecordListResponse.Content.RecordInfo {
  public struct FileUrl: BaseResponse {
    public let videoUrl: String
    public let thumbnailUrl: String

    public init(
      videoUrl: String,
      thumbnailUrl: String
    ) {
      self.videoUrl = videoUrl
      self.thumbnailUrl = thumbnailUrl
    }
  }
}

extension DTO.GetUserRecordListResponse {
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

