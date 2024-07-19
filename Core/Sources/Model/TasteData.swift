//
//  TasteData.swift
//  Core
//
//  Created by 한지석 on 7/20/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct TasteData {
  public let title: String
  public let percentage: Int
  public let type: TasteCase

  public init(
    title: String,
    percentage: Int,
    type: TasteCase
  ) {
    self.title = title
    self.percentage = percentage
    self.type = type
  }
}

public enum TasteCase: Int {
  case large
  case medium
  case small
}
