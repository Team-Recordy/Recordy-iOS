//
//  PlaceReview.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct PlaceReview {
  public let rating: Double
  public let comments: String
  
  public init(
    rating: Double,
    comments: String
  ) {
    self.rating = rating
    self.comments = comments
  }
}
