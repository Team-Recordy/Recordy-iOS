//
//  RecordyTabBarType.swift
//  Presentation
//
//  Created by 한지석 on 7/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

@available(iOS 16.0, *)
enum RecordyTabBarType: CaseIterable {
  case home
  case video
  case profile

  var active: UIImage {
    switch self {
    case .home:
      CommonAsset.homeActive.image
    case .video:
      CommonAsset.videoActive.image
    case .profile:
      CommonAsset.profileActive.image
    }
  }
  var inactive: UIImage {
    switch self {
    case .home:
      CommonAsset.homeInactive.image
    case .video:
      CommonAsset.videoInactive.image
    case .profile:
      CommonAsset.profileInactive.image
    }
  }
  
  var viewController: UIViewController {
    switch self {
    case .home:
      HomeViewController()
    case .video:
      VideoFeedViewController()
    case .profile:
      BaseNavigationController(rootViewController: TasteViewController())
    }
  }
}
