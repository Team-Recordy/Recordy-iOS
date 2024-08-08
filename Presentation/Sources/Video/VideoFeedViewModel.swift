//
//  VideoFeedViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core

enum VideoFeedType {
  case all
  case following
  case famous
  case recent
  case userProfile
  case myProfile
  case bookmarked
}

class VideoFeedViewModel {

  private(set) var feedList: [Feed] = []
  var type: VideoFeedType
  var cursorId: Int?
  var currentId: Int?
  var userId: Int?
  var keyword: Keyword?
  var hasNext = true
  var pageNumber = 0
  let apiProvider = APIProvider<APITarget.Records>()
  var isFetching = false
  var onFeedListUpdate: (() -> ())?
  var isBookmarked: (() -> ())?

  init(
    type: VideoFeedType,
    keyword: Keyword? = nil,
    currentId: Int? = nil,
    cursorId: Int? = nil,
    userId: Int? = nil
  ) {
    self.type = type
    self.keyword = keyword
    self.currentId = currentId
    self.cursorId = cursorId
    self.userId = userId
    recordListCase()
  }

  func recordListCase(toggle: Bool? = nil) {
    switch type {
    case .all:
      getAllRecordList(toggle: toggle ?? false)
    case .following:
      getFollowRecordList()
    case .famous:
      getFamousRecordList()
    case .recent:
      getRecentRecordList()
    case .userProfile:
      getUserProfileRecordList()
    case .bookmarked:
      getBookmarkedFeedList()
    default: return
    }
  }

  private func getRecordList<T: Codable>(endPoint: APITarget.Records, response: T) {
    guard !isFetching else { return }
    isFetching = true
    apiProvider.requestResponsable(
      endPoint,
      T.self
    ) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        print(response)
      case .failure(let failure):
        self.feedList = []
        self.onFeedListUpdate?()
      }
    }
  }

  private func processResponse<T: Codable> (
    response: T,
    toggle: Bool
  ) {
    switch type {
    case .all:
      <#code#>
    case .following:
      <#code#>
    case .famous:
      <#code#>
    case .recent:
      <#code#>
    case .userProfile:
      <#code#>
    case .myProfile:
      <#code#>
    case .bookmarked:
      <#code#>
    }
  }

  private func getAllRecordList(toggle: Bool) {
    guard !isFetching else { return }
    hasNext = false
    isFetching = true
    let request = DTO.GetRecordListRequest(size: 15)
    apiProvider.requestResponsable(
      .getRecordList(request),
      DTO.RecordList.self
    ) { result in
      self.isFetching = false
      switch result {
      case .success(let response):
        if toggle {
          self.feedList = response.feeds
        } else {
          self.feedList += response.feeds
        }
        self.onFeedListUpdate?()
      case .failure(let error):
        //TODO: 실패 시 예외처리 필요
        self.feedList = []
        self.onFeedListUpdate?()
      }
    }
  }

  private func getFollowRecordList() {
    guard !isFetching,
          let cursorId = cursorId
    else { return }
    isFetching = true
    let request = DTO.GetFollowingRecordListRequest(
      cursorId: cursorId,
      size: 15
    )
    apiProvider.requestResponsable(
      .getFollowingRecordList(request),
      DTO.GetFollowingRecordListResponse.self
    ) { result in
      self.isFetching = false
      switch result {
      case .success(let response):
        self.feedList += response.feeds
        self.cursorId = response.nextCursor
        self.onFeedListUpdate?()
      case .failure(let failure):
        //TODO: 실패 시 예외처리 필요
        self.feedList = []
        self.onFeedListUpdate?()
      }
    }
  }

  private func getFamousRecordList() {
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
        //TODO: 실패 시 예외처리 필요
        print(failure)
      }
    }
  }

  private func getRecentRecordList() {
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
        //TODO: 실패 시 예외처리 필요
        print(failure)
      }
    }
  }

  private func getUserProfileRecordList() {
    guard !isFetching,
          let currentId = currentId,
          let userId = userId
    else {
      return
    }
    let request = DTO.GetUserRecordListRequest(
      otherUserId: userId,
      cursorId: 0,
      size: 100
    )
    apiProvider.requestResponsable(.getUserRecordList(request), DTO.GetUserRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        if let index = response.feeds.firstIndex(where: { $0.id == currentId }) {
          let newFeeds = Array(response.feeds[index...])
          self.feedList = newFeeds
          self.onFeedListUpdate?()
        }
      case .failure(let failure):
        //TODO: 실패 시 예외처리 필요
        print(failure)
      }
    }
  }

  private func getBookmarkedFeedList() {
    guard !isFetching,
          let currentId = currentId,
          hasNext
    else { return }
    let request = DTO.GetBookmarkedListRequest(
      cursorId: 0,
      size: 100
    )
    apiProvider.requestResponsable(.getBookmarkedRecordList(request), DTO.GetBookmarkedListResponse.self) { result in
      self.isFetching = false
      switch result {
      case .success(let response):
        if let index = response.feeds.firstIndex(where: { $0.id == currentId }) {
          let newFeeds = Array(response.feeds[index...])
          self.hasNext = response.hasNext
          self.feedList = newFeeds
          self.onFeedListUpdate?()
        }
      case .failure(let failure):
        //TODO: 실패 시 예외처리 필요
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

  func deleteFeed(_ index: Int) {
    let feed = self.feedList[index]
    let request = DTO.DeleteRecordRequest(record_id: feed.id)
    apiProvider.justRequest(.deleteRecord(request)) { result in
      switch result {
      case .success(let success):
        print(success)
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
