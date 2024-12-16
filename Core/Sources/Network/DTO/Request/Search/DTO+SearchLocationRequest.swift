//
//  DTO+SearchLocationRequest.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

extension DTO {
  public struct SearchLocationRequest: BaseRequest {
    public let query: String
    public let page: Int
    
    public init(
      query: String,
      page: Int
    ) {
      self.query = query
      self.page = page
    }
  }
}
