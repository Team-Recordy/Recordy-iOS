//
//  DTO+GetRecordListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetRecordListResponse: BaseResponse {
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

extension DTO.GetRecordListResponse {
  public struct Content: BaseResponse {
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

extension DTO.GetRecordListResponse.Content {
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

//
//extension DTO {
//  public typealias RecordList = [GetRecordListResponse]
//  
//  public struct GetRecordListResponse: BaseResponse {
//    let recordInfo: RecordInfo
//    let isBookmark: Bool
//    
//    init(
//      recordInfo: RecordInfo,
//      isBookmark: Bool
//    ) {
//      self.recordInfo = recordInfo
//      self.isBookmark = isBookmark
//    }
//  }
//}
//
//extension DTO.GetRecordListResponse {
//  public struct RecordInfo: BaseResponse {
//    public let id: Int
//    public let fileUrl: FileUrl
//    public let location: String
//    public let content: String
//    public let uploaderId: Int
//    public let uploaderNickname: String
//    public let bookmarkCount: Int
//    public let isMine: Bool
//
//    init(
//      id: Int,
//      fileUrl: FileUrl,
//      location: String,
//      content: String,
//      uploaderId: Int,
//      uploaderNickname: String,
//      bookmarkCount: Int,
//      isMine: Bool
//    ) {
//      self.id = id
//      self.fileUrl = fileUrl
//      self.location = location
//      self.content = content
//      self.uploaderId = uploaderId
//      self.uploaderNickname = uploaderNickname
//      self.bookmarkCount = bookmarkCount
//      self.isMine = isMine
//    }
//  }
//}
//
//extension DTO.GetRecordListResponse.RecordInfo {
//  public struct FileUrl: BaseResponse {
//    let videoUrl: String
//    let thumbnailUrl: String
//
//    init(
//      videoUrl: String,
//      thumbnailUrl: String
//    ) {
//      self.videoUrl = videoUrl
//      self.thumbnailUrl = thumbnailUrl
//    }
//  }
//}

//extension DTO.RecordList {
//  public var feeds: [Feed] {
//    return self.map { response in
//      Feed(
//        id: response.recordInfo.id,
//        userId: response.recordInfo.uploaderId,
//        location: response.recordInfo.location,
//        placeInfo: PlaceInfo(
//          feature: .all,
//          title: "국현미",
//          duration: "2024.10.03~"
//        ),
//        nickname: response.recordInfo.uploaderNickname,
//        description: response.recordInfo.content,
//        isBookmarked: response.isBookmark,
//        bookmarkCount: response.recordInfo.bookmarkCount,
//        videoLink: response.recordInfo.fileUrl.videoUrl,
//        thumbnailLink: response.recordInfo.fileUrl.thumbnailUrl,
//        isMine: response.recordInfo.isMine
//      )
//    }
//  }
//}
