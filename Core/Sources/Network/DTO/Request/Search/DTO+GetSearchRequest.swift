//
//  DTO+GetSearchRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct GetSearchRequest: BaseRequest {
    public let query: String
    
    public init(query: String) {
      self.query = query
    }
  }
}
