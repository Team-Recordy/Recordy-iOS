//
//  VideoFeedViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core

import RxSwift
import RxCocoa

class VideoFeedViewModel {

  struct Input {
    let fetchVideos: PublishRelay<Void>
    let currentIndex: PublishRelay<Int>
  }

  struct Output {
    let videoList: Driver<[URL]>
    let currentVideo: Driver<URL?>
  }

  private let disposeBag = DisposeBag()
  let videoListRelay = BehaviorRelay<[URL]>(value: [])
  private let currentVideoRelay = BehaviorRelay<URL?>(value: nil)

  func transform(input: Input) -> Output {
    input.fetchVideos
      .subscribe { [weak self] _ in
        self?.getVideos()
      }.disposed(by: disposeBag)

    input.currentIndex
      .subscribe { [weak self] index in
        guard let self = self,
              let index = index.element
        else { return }
        let currentVideo = self.videoListRelay.value[index]
        self.currentVideoRelay.accept(currentVideo)
      }.disposed(by: disposeBag)
    
    return Output(
      videoList: videoListRelay.asDriver(),
      currentVideo: currentVideoRelay.asDriver()
    )
  }

  private func getVideos() {
    let videos: [URL] = [
      URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
      URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")!,
      URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")!
    ]

    let dispatchGroup = DispatchGroup()
    var cachedVideos: [URL] = []

    for video in videos {
      dispatchGroup.enter()
      VideoCacheManager.shared.downloadAndCacheURL(url: video) { url in
        if let url = url {
          cachedVideos.append(url)
        }
        dispatchGroup.leave()
      }
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }
      self.videoListRelay.accept(self.videoListRelay.value + cachedVideos)
    }
  }
}
