//
//  DTO+GetRandomRecordListResponse.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetRandomRecordListResponse: BaseResponse {
    public let records: [Record]

    public init(records: [Record]) {
      self.records = records
    }

    public init(from decoder: Decoder) throws {
      // 배열을 바로 디코딩
      let container = try decoder.singleValueContainer()
      records = try container.decode([Record].self)
    }
  }
}

extension DTO.GetRandomRecordListResponse {
  public struct Record: BaseResponse {
    public let id: Int
    public let fileUrl: FileUrl
    public let content: String
    public let exhibitionName: String
    public let placeId: Int
    public let placeName: String
    public let uploaderId: Int
    public let uploaderNickname: String
    public let bookmarkCount: Int
    public let isMine: Bool
    public let isBookmarked: Bool

    public init(
      id: Int,
      fileUrl: FileUrl,
      content: String,
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
      self.fileUrl = fileUrl
      self.content = content
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
}

extension DTO.GetRandomRecordListResponse.Record {
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
