//
//  DTO+GetFamousRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFamousRecordListResponse: BaseResponse {
    public let pageNumber: Int
    public let hasNext: Bool
    public let content: [Content]

    public init(pageNumber: Int, hasNext: Bool, content: [Content]) {
      self.pageNumber = pageNumber
      self.hasNext = hasNext
      self.content = content
    }
  }
}

extension DTO.GetFamousRecordListResponse {
  public struct Content: BaseResponse {
    public let recordInfo: RecordInfo
    public let isBookmark: Bool

    public init(recordInfo: RecordInfo, isBookmark: Bool) {
      self.recordInfo = recordInfo
      self.isBookmark = isBookmark
    }
  }
}

extension DTO.GetFamousRecordListResponse.Content {
  public struct RecordInfo: BaseResponse {
    public let id: Int
    public let fileUrl: FileUrl
    public let location: String
    public let content: String
    public let uploaderId: Int
    public let uploaderNickname: String
    public let bookmarkCount: Int
    public let isMine: Bool

    public init(id: Int, fileUrl: FileUrl, location: String, content: String, uploaderId: Int, uploaderNickname: String, bookmarkCount: Int, isMine: Bool) {
      self.id = id
      self.fileUrl = fileUrl
      self.location = location
      self.content = content
      self.uploaderId = uploaderId
      self.uploaderNickname = uploaderNickname
      self.bookmarkCount = bookmarkCount
      self.isMine = isMine
    }
  }
}

extension DTO.GetFamousRecordListResponse.Content.RecordInfo {
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

extension DTO.GetFamousRecordListResponse {
  public var feeds: [Feed] {
    return content.map {
      Feed(
        id: $0.recordInfo.id,
        userId: $0.recordInfo.uploaderId,
        location: $0.recordInfo.location,
        nickname: $0.recordInfo.uploaderNickname,
        description: $0.recordInfo.content,
        bookmarkCount: $0.recordInfo.bookmarkCount,
        isBookmarked: $0.isBookmark,
        videoLink: $0.recordInfo.fileUrl.videoUrl,
        thumbnailLink: $0.recordInfo.fileUrl.thumbnailUrl,
        isMine: $0.recordInfo.isMine
      )
    }
  }
}
