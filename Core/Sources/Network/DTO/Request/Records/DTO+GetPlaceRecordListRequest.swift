//
//  DTO+GetPlaceRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPlaceRecordListRequest: BaseRequest {
    public let placeId: Int
    public let cursorId: Int
    /// 요청 리스트 사이즈, 디폴트 10
    public let size: Int
    
    public init(
      cursorId: Int,
      placeId: Int,
      size: Int
    ) {
      self.cursorId = cursorId
      self.placeId = placeId
      self.size = size
    }
  }
}
