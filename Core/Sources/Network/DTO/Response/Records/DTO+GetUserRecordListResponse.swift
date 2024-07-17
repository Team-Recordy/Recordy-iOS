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
    public let nextCursor: Int
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
