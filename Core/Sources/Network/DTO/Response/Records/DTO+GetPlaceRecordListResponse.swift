//
//  DTO+GetPlaceRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPlaceRecordListResponse: Codable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let content: [Content]
    
    public init(
      nextCursor: Int?,
      hasNext: Bool,
      content: [Content]
    ) {
      self.nextCursor = nextCursor
      self.hasNext = hasNext
      self.content = content
    }
  }
}

extension DTO.GetPlaceRecordListResponse {
  public struct Content: Codable {
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
      uploaderNickname: String = "Unknown",
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
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decode(Int.self, forKey: .id)
      self.fileUrl = try container.decode(FileUrl.self, forKey: .fileUrl)
      self.content = try container.decode(String.self, forKey: .content)
      self.exhibitionName = try container.decode(String.self, forKey: .exhibitionName)
      self.placeId = try container.decode(Int.self, forKey: .placeId)
      self.placeName = try container.decode(String.self, forKey: .placeName)
      self.uploaderId = try container.decode(Int.self, forKey: .uploaderId)
      self.uploaderNickname = try container.decodeIfPresent(String.self, forKey: .uploaderNickname) ?? "Unknown"
      self.bookmarkCount = try container.decode(Int.self, forKey: .bookmarkCount)
      self.isMine = try container.decode(Bool.self, forKey: .isMine)
      self.isBookmarked = try container.decode(Bool.self, forKey: .isBookmarked)
    }
  }
}

extension DTO.GetPlaceRecordListResponse.Content {
  public struct FileUrl: Codable {
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
