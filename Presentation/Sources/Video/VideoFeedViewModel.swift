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

enum VideoFeedType {
  case all
  case famous
  case recent
}

class VideoFeedViewModel {

  private(set) var feedList: [Feed] = []
  let type: VideoFeedType
  var cursorId: Int?
  var currentId: Int?
  var keyword: Keyword?
  var pageNumber = 0
  let apiProvider = APIProvider<APITarget.Records>()
  let disposeBag = DisposeBag()
  var isFetching = false
  var onFeedListUpdate: (() -> ())?
  var isBookmarked: (() -> ())?

  init(
    type: VideoFeedType,
    keyword: Keyword? = nil,
    currentId: Int? = nil,
    cursorId: Int? = nil
  ) {
    self.type = type
    self.keyword = keyword
    self.currentId = currentId
    self.cursorId = cursorId
    recordListCase()
  }

  func recordListCase() {
    switch type {
    case .all:
      getRecordList()
    case .famous:
      getFamousRecordList()
    case .recent:
      getRecentRecordList()
    }
  }

  func getRecordList() {
    guard !isFetching else { return }
    isFetching = true
    let request = DTO.GetRecordListRequest(size: 15)
    apiProvider.requestResponsable(
      .getRecordList(
        request
      ),
      DTO.RecordList.self
    ) { result in
      self.isFetching = false
      switch result {
      case .success(let response):
        self.feedList += response.feeds
        self.onFeedListUpdate?()
      case .failure(let error):
        print(error)
      }
    }
  }

  func getFamousRecordList() {
    guard !isFetching else { return }
    isFetching = true
    var selectedKeyword: String?
    if keyword != .all {
      selectedKeyword = keyword?.title.keywordEncode()
    } else {
      selectedKeyword = nil
    }
    let request = DTO.GetFamousRecordListRequest(
      keywords: selectedKeyword,
      pageNumber: pageNumber,
      pageSize: 15
    )
    apiProvider.requestResponsable(
      .getFamousRecordList(request),
      DTO.GetFamousRecordListResponse.self
    ) { result in
      self.isFetching = false
      switch result {
      case .success(let response):
        if self.pageNumber == 0 {
          if let index = response.feeds.firstIndex(where: { $0.id == self.currentId }) {
            let newFeeds = Array(response.feeds[index...])
            self.feedList += newFeeds
          }
        } else {
          self.feedList += response.feeds
        }
        self.pageNumber += 1
        self.onFeedListUpdate?()
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func getRecentRecordList() {
    guard !isFetching,
          let cursorId = cursorId,
          let currentId = currentId
    else { return }
    isFetching = true
    var selectedKeyword: String?
    if keyword != .all {
      selectedKeyword = keyword?.title.keywordEncode()
    } else {
      selectedKeyword = nil
    }
    let request = DTO.GetRecentRecordListRequest(
      keywords: selectedKeyword,
      cursorId: cursorId,
      size: 15
    )
    apiProvider.requestResponsable(
      .getRecentRecordList(request),
      DTO.GetRecentRecordListResponse.self
    ) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        if cursorId == 0 {
          if let index = response.feeds.firstIndex(where: { $0.id == currentId }) {
            let newFeeds = Array(response.feeds[index...])
            self.feedList += newFeeds
          }
        } else {
          self.feedList += response.feeds
        }
        self.cursorId = response.nextCursor
        self.onFeedListUpdate?()
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func cacheVideos(
    feeds: [Feed],
    completion: @escaping () -> Void) {
      let dispatchGroup = DispatchGroup()
      var cachedFeeds: [Feed] = []

      for feed in feeds {
        dispatchGroup.enter()

        VideoCacheManager.shared.downloadAndCacheURL(url: URL(string: feed.videoLink)!) { url in
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
        self.feedList += newFeeds
        completion()
      }
    }

  func postIsFeedWatched(feed: Feed) {
    let request = DTO.IsRecordWatchedRequest(recordId: feed.id)
    apiProvider.justRequest(.isRecordWatched(request)) { result in
      switch result {
      case .success:
        print("@Log - success")
      case .failure(let failure):
        print(failure)
      }
    }
  }

  func bookmarkButtonTapped(_ index: Int) {
    self.feedList[index].isBookmarked.toggle()
    let count = self.feedList[index].isBookmarked ? 1 : -1
    self.feedList[index].bookmarkCount += count
    let bookmarkProvider = APIProvider<APITarget.Bookmark>()
    let request = DTO.PostBookmarkRequest(recordId: feedList[index].id)
    bookmarkProvider.justRequest(.postBookmark(request)) { result in
      switch result {
      case .success:
        print("@Log - success")
      case .failure(let failure):
        print(failure)
      }
    }
  }
}

//
//  func fetchMoreVideos(completion: @escaping () -> Void) {
//    let feeds: [Feed] = Feed.mockdata1
//    let dispatchGroup = DispatchGroup()
//    var cachedFeeds: [Feed] = []
//
//    for feed in feeds {
//      dispatchGroup.enter()
//      VideoCacheManager.shared.downloadAndCacheURL(url: feed.videoLink) { url in
//        guard url != nil else {
//          dispatchGroup.leave()
//          return
//        }
//        cachedFeeds.append(feed)
//        dispatchGroup.leave()
//      }
//    }
//    dispatchGroup.notify(queue: .main) { [weak self] in
//      guard let self = self else { return }
//      let newFeeds = cachedFeeds.filter { newFeed in
//        !self.feedList.contains(where: { $0.id == newFeed.id })
//      }
//      self.feedList.append(contentsOf: newFeeds)
//      completion()
//    }
//  }
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
