//
//  DTO+EditUserInfoRequest.swift
//  Core
//
//  Created by Chandrala on 12/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct EditUserInfoRequest: BaseRequest {
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
