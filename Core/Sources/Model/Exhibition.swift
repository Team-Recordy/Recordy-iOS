//
//  Exhibition.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Exhibition: Decodable {
  public let id: Int
  public let name: String
  public let startDate: String
  public let endDate: String
  public let isFree: Bool

  public init(
    id: Int,
    name: String,
    startDate: String,
    endDate: String,
    isFree: Bool
  ) {
    self.id = id
    self.name = name
    self.startDate = startDate
    self.endDate = endDate
    self.isFree = isFree
  }
}
