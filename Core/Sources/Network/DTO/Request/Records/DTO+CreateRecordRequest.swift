//
//  DTO+CreateRecordRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct CreateRecordRequest: BaseRequest {
    /// 위치 정보
    public let location: String
    /// 내용
    public let content: String
    /// 선택 키워드 - encoding etf8
    public let keywords: [String]
    public let fileUrl: FileUrl

    public init(
      location: String,
      content: String,
      keywords: [String],
      fileUrl: FileUrl
    ) {
      self.location = location
      self.content = content
      self.keywords = keywords
      self.fileUrl = fileUrl
    }
  }
}

extension DTO.CreateRecordRequest {
  /// s3 요청 성공 시 반환되는 링크를 Request에 담아서 요청해야 함
  public struct FileUrl: BaseRequest {
    let videoUrl: String
    let thumbnailUrl: String

    public init(
      videoUrl: String,
      thumbnailUrl: String
    ) {
      self.videoUrl = videoUrl
      self.thumbnailUrl = thumbnailUrl
    }
  }
}
