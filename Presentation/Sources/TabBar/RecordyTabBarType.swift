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
  case search
  case upload
  case video
  case profile

  var active: UIImage {
    switch self {
    case .home:
      CommonAsset.homeActive.image
    case .search:
      CommonAsset.searchActive.image
    case .upload:
      CommonAsset.uploadActive.image
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
    case .search:
      CommonAsset.searchInactive.image
    case .upload:
      CommonAsset.uploadInactive.image
    case .video:
      CommonAsset.videoInactive.image
    case .profile:
      CommonAsset.profileInactive.image
    }
  }
  
  var viewController: UIViewController {
    switch self {
    case .home:
      BaseNavigationController(rootViewController: OverviewViewController(viewModel: OverviewViewModel()))
    case .search:
      BaseNavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel()))
    case .upload:
      BaseNavigationController(rootViewController: UploadVideoViewController())
    case .video:
      BaseNavigationController(rootViewController: VideoFeedViewController(type: .all))
    case .profile:
      BaseNavigationController(rootViewController: ProfileViewController())
    }
  }
}
