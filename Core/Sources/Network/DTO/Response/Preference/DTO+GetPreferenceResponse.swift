//
//  DTO+GetPreferenceResponse.swift
//  Core
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetPreferenceResponse: BaseResponse {
    public let preference: [[String]]
    
    public init(preference: [[String]]) {
      self.preference = preference
    }
  }
}
