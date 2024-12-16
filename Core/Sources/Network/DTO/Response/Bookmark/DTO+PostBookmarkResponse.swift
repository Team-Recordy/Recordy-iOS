//
//  DTO+PostBookmarkResponse.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct PostBookmarkResponse: BaseRequest {
    public let isBookmarked: Bool
    
    public init(isBookmarked: Bool) {
      self.isBookmarked = isBookmarked
    }
  }
}
