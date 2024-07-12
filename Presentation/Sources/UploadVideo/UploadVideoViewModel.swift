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
import Common

import RxSwift
import RxCocoa

/// 시스템 권한을 이 뷰모델에서 판단하여야 함
final class UploadVideoViewModel {

//  let asset: PHAsset

  struct Input {
    let selectedAsset = BehaviorRelay<PHAsset?>(value: nil)
    let selectedKeywords = BehaviorRelay<[Keyword]>(value: [.classic, .cozy, .neat])
    let location = PublishRelay<String>()
    let contents = PublishRelay<String>()
  }

  struct Output {
    let thumbnailImage = BehaviorRelay<UIImage?>(value: nil)
    let locationTextCount = BehaviorRelay<String>(value: "0 / 20")
    let contentsTextCount = BehaviorRelay<String>(value: "0 / 300")
    let uploadEnabled = BehaviorRelay<Bool>(value: false)
    let uploadVideo = BehaviorRelay<PHAsset?>(value: nil)
  }

  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()

  init() {
//    self.input.selectedAsset.accept(asset)
    self.bind()
  }

  func bind() {
    input.selectedAsset
       .compactMap { asset -> UIImage? in
         guard let asset = asset else { return nil }
         return PhotoKitManager.getAssetThumbnail(
           asset: asset,
           size: CGSize(width: 180, height: 284)
         )
       }
       .bind(to: output.thumbnailImage)
       .disposed(by: disposeBag)

    input.location
      .map { "\($0.count) / 20" }
      .bind(to: output.locationTextCount)
      .disposed(by: disposeBag)

    input.contents
      .map { "\($0.count) / 300" }
      .bind(to: output.contentsTextCount)
      .disposed(by: disposeBag)

    Observable.combineLatest(
      output.uploadVideo,
      input.selectedKeywords,
      input.location,
      input.contents
    ).map { asset, keywords, location, contents in
      return asset != nil && keywords.count == 3 && location.count > 0 && contents.count > 0
    }
    .bind(to: output.uploadEnabled)
    .disposed(by: disposeBag)
  }
}
