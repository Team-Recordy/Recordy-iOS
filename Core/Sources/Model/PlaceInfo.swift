//
//  PlaceInfo.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct PlaceInfo: Equatable {
  let feature: PlaceFeature
  let title: String
  let duration: String

  public init(
    feature: PlaceFeature,
    title: String,
    duration: String
  ) {
    self.feature = feature
    self.title = title
    self.duration = duration
  }
}

public enum PlaceFeature {
  case all
  case free
  case closingSoon
}
