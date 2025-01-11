//
//  SearchResult.swift
//  Core
//
//  Created by Chandrala on 1/10/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation

public struct SearchResult {
  public let id: Int
  public let type: String
  public let address: String
  public let name: String
  
  public init(
    id: Int,
    type: String,
    address: String,
    name: String
  ) {
    self.id = id
    self.type = type
    self.address = address
    self.name = name
  }
}
