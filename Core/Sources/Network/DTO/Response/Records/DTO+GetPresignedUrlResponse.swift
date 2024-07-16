//
//  DTO+GetPresignedUrlResponse.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPresignedUrlResponse: BaseResponse {
    let videoUrl: String
    let thumbnailUrl: String

    public init(
      videoUrl: String,
      thumbnailUrl: String
    ) {
      self.videoUrl = videoUrl
      self.thumbnailUrl = thumbnailUrl
    }
  }
}
