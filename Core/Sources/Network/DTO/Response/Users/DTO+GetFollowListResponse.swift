//
//  DTO+GetFollowListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFollowListResponse: BaseResponse {
    /// 다음 커서
    public let nextCursor: Int
    /// 다음 페이지 여부
    public let hasNext: Bool
    /// 다음 커서
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

extension DTO.GetFollowListResponse {
  public struct Content: BaseResponse {
    /// 사용자
    public let id: Int
    /// 닉네임
    public let nickname: String
    /// 프로필 사진
    public let profileImageUrl: String

    public init(
      id: Int,
      nickname: String,
      profileImageUrl: String
    ) {
      self.id = id
      self.nickname = nickname
      self.profileImageUrl = profileImageUrl
    }
  }
}
