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
    /// 다음 커서
    public let nextCursor: Int?
    /// 다음 페이지 여부
    public let hasNext: Bool
    /// 다음 커서
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
    public let userInfo: UserInfo
    public let following: Bool
    
    public init(
      userInfo: UserInfo,
      following: Bool
    ) {
      self.userInfo = userInfo
      self.following = following
    }
  }
}

extension DTO.GetFollowerListResponse.Content {
  public struct UserInfo: Codable {
    public let id: Int
    public let nickname: String
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



// MARK: - UserInfo
