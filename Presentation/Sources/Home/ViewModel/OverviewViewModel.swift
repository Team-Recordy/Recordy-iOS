//
//  OverviewViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

public enum LocationState {
  case active
  case inactive
  
  var buttonImage: UIImage {
    switch self {
    case .active:
      return CommonAsset.locationActive.image
    case .inactive:
      return CommonAsset.locationInactive.image
    }
  }
}

public class OverviewViewModel {
  private(set) var locationState: LocationState = .inactive {
    didSet {
      onLocationStateChanged?(locationState)
    }
  }
  
  var onLocationStateChanged: ((LocationState) -> Void)?
  
  func updateLocationState() {
    locationState = (locationState == .active) ? .inactive : .active
  }
}
