//
//  UploadVideoViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/3/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos
import UIKit

import RxSwift
import RxCocoa

final class UploadVideoViewModel {

  /// Relay VS Subject
  /// Relay - 에러처리가 필요 없을 경우, UI 이벤트에 적합
  /// Subject - 에러처리를 해야할 경우
  /// PublishRelay는 주로 UI 이벤트와 같은 에러가 필요 없는 간단한 이벤트 스트림에 적합
  /// PublishSubject는 에러 처리가 필요한 스트림에 적합합니
  struct Input {
    let fetchVideos: PublishRelay<Void>
    let selectedVideo: PublishRelay<IndexPath>
  }

  struct Output {
    let asset: Driver<[PHAsset]>
    let fetchStatus: Driver<Bool>
    let selectedIndexPath: Driver<IndexPath?>
  }

  private let disposeBag = DisposeBag()

  private let assetsRelay = BehaviorRelay<[PHAsset]>(value: [])
  private let fetchStatusRelay = PublishRelay<Bool>()
  private let selectedIndexPathRelay = BehaviorRelay<IndexPath?>(value: nil)

  func transform(input: Input) -> Output {
    input.fetchVideos
      .subscribe(onNext: { [weak self] in
        self?.fetchVideosFromGallery()
      })
      .disposed(by: disposeBag)

    input.selectedVideo
      .subscribe { [weak self] indexPath in
        self?.selectedIndexPathRelay.accept(indexPath)
      }
      .disposed(by: disposeBag)

    return Output(
       asset: assetsRelay.asDriver(),
       fetchStatus: fetchStatusRelay.asDriver(onErrorJustReturn: false),
       selectedIndexPath: selectedIndexPathRelay.asDriver()
     )
  }

  private func fetchVideosFromGallery() {
    getPhotoPermission { [weak self] granted in
      guard granted else {
        self?.fetchStatusRelay.accept(false)
        return
      }
      self?.loadAssets()
    }
  }

  private func getPhotoPermission(completionHandler: @escaping (Bool) -> Void) {
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

  private func loadAssets() {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(
      format: "mediaType == %d",
      PHAssetMediaType.video.rawValue
    )
    
    let allVideos = PHAsset.fetchAssets(
      with: .video,
      options: fetchOptions
    )
    var videos: [PHAsset] = []
    allVideos.enumerateObjects { (asset, _, _) in
      videos.append(asset)
    }

    self.assetsRelay.accept(videos.reversed())
    self.fetchStatusRelay.accept(true)
  }

  func isSelected(indexPath: IndexPath) -> Bool {
    return indexPath == selectedIndexPathRelay.value
  }
}
