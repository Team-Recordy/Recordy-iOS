//
//  DTO+GetRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public typealias RecordList = [GetRecordListResponse]
  public struct GetRecordListResponse: BaseResponse {
    let recordInfo: RecordInfo
    let isBookmark: Bool
    
    init(
      recordInfo: RecordInfo,
      isBookmark: Bool
    ) {
      self.recordInfo = recordInfo
      self.isBookmark = isBookmark
    }
  }
}

extension DTO.GetRecordListResponse {
  public struct RecordInfo: BaseResponse {
    public let id: Int
    public let fileUrl: FileUrl
    public let location: String
    public let content: String
    public let uploaderId: Int
    public let uploaderNickname: String
    public let bookmarkCount: Int
    public let isMine: Bool

    init(
      id: Int,
      fileUrl: FileUrl,
      location: String,
      content: String,
      uploaderId: Int,
      uploaderNickname: String,
      bookmarkCount: Int,
      isMine: Bool
    ) {
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

extension DTO.GetRecordListResponse.RecordInfo {
  public struct FileUrl: BaseResponse {
    let videoUrl: String
    let thumbnailUrl: String

    init(
      videoUrl: String,
      thumbnailUrl: String
    ) {
      self.videoUrl = videoUrl
      self.thumbnailUrl = thumbnailUrl
    }
  }
}

extension DTO.RecordList {
  public var feeds: [Feed] {
    return self.map { response in
      Feed(
        id: response.recordInfo.id,
        userId: response.recordInfo.uploaderId,
        location: response.recordInfo.location,
        placeInfo: PlaceInfo(
          feature: .all,
          title: "국현미",
          duration: "2024.10.03~"
        ),
        nickname: response.recordInfo.uploaderNickname,
        description: response.recordInfo.content,
        isBookmarked: response.isBookmark,
        bookmarkCount: response.recordInfo.bookmarkCount,
        videoLink: response.recordInfo.fileUrl.videoUrl,
        thumbnailLink: response.recordInfo.fileUrl.thumbnailUrl,
        isMine: response.recordInfo.isMine
      )
    }
  }
}
