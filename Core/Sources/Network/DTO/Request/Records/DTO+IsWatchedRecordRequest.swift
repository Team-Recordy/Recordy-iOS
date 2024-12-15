//
//  DTO+IsWatchedRecordRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

//TODO: 필요없음

extension DTO {
  public struct IsRecordWatchedRequest: BaseRequest {
    let recordId: Int
    
    public init(recordId: Int) {
      self.recordId = recordId
    }
  }
}
