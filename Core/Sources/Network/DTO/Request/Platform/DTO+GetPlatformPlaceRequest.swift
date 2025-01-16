//
//  DTO+GetPlatformPlaceRequest.swift
//  Core
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation

import Foundation

extension DTO {
  public struct GetPlatformPlaceRequest: BaseRequest {
    public let query: String

    public init(query: String) {
      self.query = query
    }
  }
}
