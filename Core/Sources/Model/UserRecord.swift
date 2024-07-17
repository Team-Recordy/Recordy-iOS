//
//  UserRecord.swift
//  Core
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import Foundation

public struct UserRecord {
  public let userId: Int
  public let recordId: Int
  public let location: String
  public var isBookmarked: Bool
  
  public init(
    userId: Int,
    recordId: Int,
    location: String,
    isBookmarked: Bool
  ) {
    self.userId = userId
    self.recordId = recordId
    self.location = location
    self.isBookmarked = isBookmarked
  }
}
