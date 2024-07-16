//
//  DTO+GetRecordListRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetRecordListRequest: BaseRequest {
    /// 요청 리스트 사이즈, 디폴트 10
    public let size: Int
  }
}
