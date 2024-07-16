//
//  DTO+GetProfileResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetProfileResponse: BaseResponse {
    /// 사용자 ID
    public let id: Int
    /// 닉네임
    public let nickname: String
    /// 프로필 사진
    public let profileImageUrl: String
    /// 기록 개수
    public let recordCount: Int
    /// 팔로워 수
    public let followerCount: Int
    /// 팔로잉 수
    public let followingCount: Int
    /// 팔로잉 여부
    public let isFollwoing: Bool

    public init(
      id: Int,
      nickname: String,
      profileImageUrl: String,
      recordCount: Int,
      followerCount: Int,
      followingCount: Int,
      isFollwoing: Bool
    ) {
      self.id = id
      self.nickname = nickname
      self.profileImageUrl = profileImageUrl
      self.recordCount = recordCount
      self.followerCount = followerCount
      self.followingCount = followingCount
      self.isFollwoing = isFollwoing
    }
  }
}
