//
//  Place.swift
//  Core
//
//  Created by 한지석 on 9/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Place {
  public let shortenLocation: String
  public let detailLocation: String
  public let title: String
  public let reviewFeeds: [String]
  public let placeInfoList: [PlaceInfo]
  public let placeReview: PlaceReview
  
  public init(
    shortenLocation: String,
    detailLocation: String,
    title: String,
    reviewFeeds: [String],
    placeInfoList: [PlaceInfo],
    placeReview: PlaceReview
  ) {
    self.shortenLocation = shortenLocation
    self.detailLocation = detailLocation
    self.title = title
    self.reviewFeeds = reviewFeeds
    self.placeInfoList = placeInfoList
    self.placeReview = placeReview
  }
}
