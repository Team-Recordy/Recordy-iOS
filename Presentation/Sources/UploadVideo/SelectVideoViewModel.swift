//
//  SelectVideoViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/3/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos
import UIKit

import Core

import RxSwift
import RxCocoa

/// TODO
/// 1. 영상 15초 제한
/// 2. 토스트 메세지
/// 3. 컴포넌트 수정

final class SelectVideoViewModel {

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
    let asset: Driver<[LocalVideo]>
    let fetchStatus: Driver<Bool>
    let selectedIndexPath: Driver<IndexPath?>
  }

  private let disposeBag = DisposeBag()

  let assetsRelay = BehaviorRelay<[LocalVideo]>(value: [])
  private let fetchStatusRelay = PublishRelay<Bool>()
  let selectedIndexPathRelay = BehaviorRelay<IndexPath?>(value: nil)

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
    let localVideos = getVideoDurations(videos: videos.reversed())
    self.assetsRelay.accept(localVideos)
    self.fetchStatusRelay.accept(true)
  }

  func getVideoDurations(videos: [PHAsset]) -> [LocalVideo] {
    let localVideos = videos.map { asset in
      let minutes = Int(asset.duration) / 60
      let seconds = Int(asset.duration) % 60
      return LocalVideo(
        asset: asset,
        playtime: String(format: "%02d:%02d", minutes, seconds)
      )
    }
    return localVideos
  }

  func isSelected(indexPath: IndexPath) -> Bool {
    return indexPath == selectedIndexPathRelay.value
  }
}
