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
    options.resizeMode = .exact

    let targetSize = CGSize(width: size.width * 3, height: size.height * 3)

    var thumbnail: UIImage?
    manager.requestImage(
      for: asset,
      targetSize: targetSize,
      contentMode: .aspectFit,
      options: options
    ) { (image, info) in
      guard let thumbnailUnwrapped = image else {return}
      thumbnail = thumbnailUnwrapped
    }
    return thumbnail
  }
}
