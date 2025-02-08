//
//  DTO+GetFollowerListResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFollowerListResponse: BaseResponse {
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

extension DTO.GetFollowerListResponse {
  public struct Content: Codable {
    public let id: Int
    public let nickname: String
    public let profileImageUrl: String
    public let isFollowing: Bool
    
    public init(
      id: Int,
      nickname: String,
      profileImageUrl: String,
      isFollowing: Bool
    ) {
      self.id = id
      self.nickname = nickname
      self.profileImageUrl = profileImageUrl
      self.isFollowing = isFollowing
    }
  }
}
