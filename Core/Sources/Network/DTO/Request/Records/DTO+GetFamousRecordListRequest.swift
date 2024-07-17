//
//  DTO+GetFamousRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetFamousRecordListRequest: BaseRequest {
    public let keywords: [String]
    public let pageNumber: Int
    public let pageSize: Int

    public init(
      keywords: [String],
      pageNumber: Int,
      pageSize: Int
    ) {
      self.keywords = keywords
      self.pageNumber = pageNumber
      self.pageSize = pageSize
    }
  }
}
