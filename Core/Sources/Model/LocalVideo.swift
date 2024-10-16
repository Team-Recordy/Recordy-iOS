//
//  LocalVideo.swift
//  Core
//
//  Created by 한지석 on 10/3/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos

public struct LocalVideo {
  public var asset: PHAsset
  public var playtime: String

  public init(
    asset: PHAsset,
    playtime: String
  ) {
    self.asset = asset
    self.playtime = playtime
  }
}
