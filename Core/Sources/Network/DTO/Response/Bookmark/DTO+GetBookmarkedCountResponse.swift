//
//  DTO+GetBookmarkedCountResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetBookmarkedCountResponse: BaseResponse {
    public let bookmarkedCount: Int
    
    public init(bookmarkedCount: Int) {
      self.bookmarkedCount = bookmarkedCount
    }
  }
}
