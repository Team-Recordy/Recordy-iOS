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
  static public func getPhotoPermission(completionHandler: @escaping (Bool) -> Void) {
    guard PHPhotoLibrary.authorizationStatus() != .authorized else {
      completionHandler(true)
      return
    }
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      switch status {
      case .authorized, .limited:
        completionHandler(true)
      default:
        completionHandler(false)
      }
    }
  }

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

  static public func getAssetThumbnailData(asset: PHAsset) -> Data? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.isNetworkAccessAllowed = true
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .none

    var thumbnailData: Data?

    manager.requestImage(
      for: asset,
      targetSize: PHImageManagerMaximumSize,
      contentMode: .aspectFit,
      options: options
    ) { (image, info) in
      guard let thumbnailUnwrapped = image else { return }
      thumbnailData = thumbnailUnwrapped.jpegData(compressionQuality: 1.0)
    }
    return thumbnailData
  }

  public static func getURL(
    of asset: PHAsset,
    completionHandler: @escaping (_ responseURL: URL?) -> Void
  ) {
    let options = PHVideoRequestOptions()
    options.version = .original
    options.isNetworkAccessAllowed = true
    PHImageManager.default().requestAVAsset(
      forVideo: asset,
      options: options
    ) { (avAsset, audioMix, info) in
      if let urlAsset = avAsset as? AVURLAsset {
        let localVideoUrl = urlAsset.url
        completionHandler(localVideoUrl)
      } else {
        completionHandler(nil)
      }
    }
  }

  public static func getData(
    of asset: PHAsset,
    completionHandler: @escaping (_ data: Data?) -> Void
  ) {
    let options = PHVideoRequestOptions()
    options.version = .original
    options.isNetworkAccessAllowed = true
    PHImageManager.default().requestAVAsset(
      forVideo: asset,
      options: options
    ) { (avAsset, audioMix, info) in
      if let urlAsset = avAsset as? AVURLAsset {
        do {
          let videoData = try Data(contentsOf: urlAsset.url)
          completionHandler(videoData)
        } catch {
          print("Error converting PHAsset to Data: \(error)")
          completionHandler(nil)
        }
      } else {
        completionHandler(nil)
      }
    }
  }

  static public func saveImageDataToLocalFile(data: Data, filename: String) -> URL? {
    let tempDirectory = FileManager.default.temporaryDirectory
    let fileURL = tempDirectory.appendingPathComponent("\(filename).jpeg")

    do {
      try data.write(to: fileURL)
      return fileURL
    } catch {
      print("Error saving image data to local file: \(error)")
      return nil
    }
  }
}
