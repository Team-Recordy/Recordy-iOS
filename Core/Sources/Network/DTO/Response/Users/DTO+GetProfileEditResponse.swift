//
//  DTO+GetProfileEditResponse.swift
//  Core
//
//  Created by 송여경 on 2/10/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetProfileEditResponse: BaseResponse {
    public let nickname: String
    public let profileImageUrl: String
    
    public init(
      nickname: String,
      profileImageUrl: String
    ) {
      self.nickname = nickname
      self.profileImageUrl = profileImageUrl
    }
  }
}
