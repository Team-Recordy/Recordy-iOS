//
//  DTO+PostBookmarkRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct PostBookmarkRequest: BaseRequest {
    public let recordId: Int

    public init(recordId: Int) {
      self.recordId = recordId
    }
  }
}
