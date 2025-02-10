//
//  DTO+GetPresignedImageUrlRequest.swift
//  Core
//
//  Created by 송여경 on 2/10/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPresignedImageUrlRequest: BaseRequest {
    public let fileName: String
    public let fileType: String
  }
}
