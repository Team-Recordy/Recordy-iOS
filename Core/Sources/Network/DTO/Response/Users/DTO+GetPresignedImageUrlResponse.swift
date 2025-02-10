//
//  DTO+GetPresignedImageUrlResponse.swift
//  Core
//
//  Created by 송여경 on 2/10/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPresignedImageUrlResponse: BaseResponse {
    public let presignedUrl: String
    
    public init(
      presignedUrl: String
    ) {
      self.presignedUrl = presignedUrl
    }
  }
}
