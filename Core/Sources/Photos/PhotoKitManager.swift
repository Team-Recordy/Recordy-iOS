//
//  PhotoKitManager.swift
//  Core
//
//  Created by 한지석 on 7/3/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Photos

public final class PhotoKitManager {
  static public func getAssetThumbnail(
    asset: PHAsset,
    size: CGSize
  ) -> UIImage? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.isNetworkAccessAllowed = true
    options.deliveryMode = .highQualityFormat
    
    var thumbnail: UIImage?
    manager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: .aspectFill,
      options: options
    ) { (image, info) in
      guard let thumbnailUnwrapped = image else {return}
      thumbnail = thumbnailUnwrapped
    }
    return thumbnail
  }
}
