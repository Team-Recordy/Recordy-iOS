//
//  UploadVideoViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos
import UIKit

import Core

import RxSwift
import RxCocoa

final class UploadVideoViewModel {
  struct Input { }

  struct Output {
    let thumbnailImage: Driver<UIImage?>
  }

  let asset: PHAsset
  private let disposeBag = DisposeBag()

  init(asset: PHAsset) {
    self.asset = asset
  }

  func transform(input: Input) -> Output {
    let thumbnailImage = Observable.just(
      PhotoKitManager.getAssetThumbnail(
        asset: asset,
        size: CGSize(width: 180, height: 284)
      )
    ).asDriver(onErrorJustReturn: nil)

    return Output(thumbnailImage: thumbnailImage)
  }
}
