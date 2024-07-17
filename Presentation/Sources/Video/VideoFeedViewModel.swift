//
//  VideoFeedViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core

class VideoFeedViewModel {
  
  private(set) var feedList: [Feed] = []

  func fetchVideos(completion: @escaping () -> Void) {
    let feeds: [Feed] = Feed.mockdata
    let dispatchGroup = DispatchGroup()
    var cachedFeeds: [Feed] = []
    
    for feed in feeds {
      dispatchGroup.enter()
      VideoCacheManager.shared.downloadAndCacheURL(url: feed.videoLink) { url in
        guard url != nil else {
          dispatchGroup.leave()
          return
        }
        cachedFeeds.append(feed)
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }
      let newFeeds = cachedFeeds.filter { newFeed in
        !self.feedList.contains(where: { $0.id == newFeed.id })
      }
      self.feedList = newFeeds
      completion()
    }
  }
  
  func fetchMoreVideos(completion: @escaping () -> Void) {
    let feeds: [Feed] = []
    let dispatchGroup = DispatchGroup()
    var cachedFeeds: [Feed] = []
    
    for feed in feeds {
      dispatchGroup.enter()
      VideoCacheManager.shared.downloadAndCacheURL(url: feed.videoLink) { url in
        guard url != nil else {
          dispatchGroup.leave()
          return
        }
        cachedFeeds.append(feed)
        dispatchGroup.leave()
      }
    }
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }
      let newFeeds = cachedFeeds.filter { newFeed in
        !self.feedList.contains(where: { $0.id == newFeed.id })
      }
      self.feedList.append(contentsOf: newFeeds)
      completion()
    }
  }
  
  func bookmarkButtonTapped(_ index: Int) {
    feedList[index].isBookmarked.toggle()
  }
}

//class VideoFeedViewModel {
//
//  struct Input {
//    let fetchVideos = PublishRelay<Void>()
//    let currentIndex = BehaviorRelay<Int?>(value: nil)
//    let bookmarkTapped = PublishRelay<Int>()
//    let playRequest = PublishRelay<Int>()
//    let fetchMoreVideos = PublishRelay<Void>()
//  }
//
//  struct Output {
//    let feedList = BehaviorRelay<[Feed]>(value: [])
//    let currentFeed = BehaviorRelay<Feed?>(value: nil)
//  }
//
//  private let disposeBag = DisposeBag()
//  let input = Input()
//  let output = Output()
//
//  init() {
//    self.bind()
//  }
//
//  func bind() {
//    self.input.fetchVideos
//      .subscribe { [weak self] _ in
//        guard let self = self else { return }
//        self.getVideos()
//      }.disposed(by: disposeBag)
//
//    self.input.currentIndex
//      .subscribe { [weak self] index in
//        guard let self = self,
//              let index = index
//        else { return }
//        let currentFeed = self.output.feedList.value[index]
//        self.output.currentFeed.accept(currentFeed)
//      }.disposed(by: disposeBag)
//
//    self.input.bookmarkTapped
//      .subscribe { [weak self] index in
//        guard let self = self else { return }
//        self.bookmarkButtonTapped(index)
//      }.disposed(by: disposeBag)
//
//    self.input.fetchMoreVideos
//      .subscribe { [weak self] _ in
//        guard let self = self else { return }
//        self.getMoreVideos()
//      }
//      .disposed(by: disposeBag)
//
//
//    self.input.fetchVideos.accept(())
//  }
//
//  func getVideos() {
//    let feeds: [Feed] = Feed.mockdata
//    let dispatchGroup = DispatchGroup()
//    var cachedFeeds: [Feed] = []
//
//    for feed in feeds {
//      dispatchGroup.enter()
//      VideoCacheManager
//        .shared
//        .downloadAndCacheURL(url: feed.videoLink) { url in
//          guard url != nil else {
//            dispatchGroup.leave()
//            return
//          }
//          cachedFeeds.append(feed)
//          dispatchGroup.leave()
//        }
//    }
//    dispatchGroup.notify(queue: .main) { [weak self] in
//      guard let self = self else { return }
//      let newFeeds = cachedFeeds.filter { newFeed in
//        !self.output.feedList.value.contains(where: { $0.id == newFeed.id })
//      }
//      self.output.feedList.accept(newFeeds)
//      self.input.currentIndex.accept(0)
//    }
//  }
//
//  func getMoreVideos() {
//    print(#function)
//    let feeds: [Feed] = Feed.mockdata1
//    let dispatchGroup = DispatchGroup()
//    var cachedFeeds: [Feed] = []
//
//    for feed in feeds {
//      dispatchGroup.enter()
//      VideoCacheManager
//        .shared
//        .downloadAndCacheURL(url: feed.videoLink) { url in
//          guard url != nil else {
//            dispatchGroup.leave()
//            return
//          }
//          cachedFeeds.append(feed)
//          dispatchGroup.leave()
//        }
//    }
//    print(cachedFeeds)
//    dispatchGroup.notify(queue: .main) { [weak self] in
//      guard let self = self else { return }
//      self.output.feedList.accept(cachedFeeds)
//    }
//  }
//
//  private func bookmarkButtonTapped(_ index: Int) {
//    var feeds = self.output.feedList.value
//    feeds[index].isBookmarked.toggle()
//    self.output.feedList.accept(feeds)
//  }
//}
