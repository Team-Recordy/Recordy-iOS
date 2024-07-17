//
//  FamousRecord.swift
//  Core
//
//  Created by Chandrala on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct MainRecord {
  public let id: Int
  public let thumbnailUrl: String
  public let location: String
  public var isBookmarked: Bool
  
  public init(
    id: Int,
    thumbnailUrl: String,
    location: String,
    isBookmarked: Bool
  ) {
    self.id = id
    self.thumbnailUrl = thumbnailUrl
    self.location = location
    self.isBookmarked = isBookmarked
  }
}
