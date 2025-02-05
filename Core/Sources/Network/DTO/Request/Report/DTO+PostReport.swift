//
//  DTO+PostReport.swift
//  Core
//
//  Created by 한지석 on 2/6/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation

extension DTO {
  public struct PostReport: BaseRequest {
    public let recordId: Int
    public let reason: String
    public let content: String

    public init(
      recordId: Int,
      reason: String,
      content: String
    ) {
      self.recordId = recordId
      self.reason = reason
      self.content = content
    }
  }
}
