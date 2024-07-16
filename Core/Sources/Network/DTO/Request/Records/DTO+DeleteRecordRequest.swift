//
//  DTO+DeleteRecordRequest.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct DeleteRecordRequest: BaseRequest {
    public let record_id: Int

    public init(record_id: Int) {
      self.record_id = record_id
    }
  }
}
