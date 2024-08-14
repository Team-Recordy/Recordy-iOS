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
  var isToggle = false
  var onFeedListUpdate: ((Int) -> ())?
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
    guard !isFetching else { return }
    switch type {
    case .all:
      getRecordList(
        endPoint: .getRecordList(DTO.GetRecordListRequest(size: 15)),
        response: DTO.RecordList.self
      )
    case .following:
      guard let cursorId else { return }
      getRecordList(
        endPoint: .getFollowingRecordList(
          DTO.GetFollowingRecordListRequest(
            cursorId: cursorId,
            size: 15
          )
        ),
        response: DTO.GetFollowingRecordListResponse.self
      )
    case .famous:
      var selectedKeyword: String?
      if keyword != .all {
        selectedKeyword = keyword?.title.keywordEncode()
      } else {
        selectedKeyword = nil
      }
      getRecordList(
        endPoint: .getFamousRecordList(
          DTO.GetFamousRecordListRequest(
            keywords: selectedKeyword,
            pageNumber: pageNumber,
            pageSize: 15
          )
        ),
        response: DTO.GetFamousRecordListResponse.self
      )
    case .recent:
      guard let cursorId, let currentId else { return }
      var selectedKeyword: String?
      if keyword != .all {
        selectedKeyword = keyword?.title.keywordEncode()
      } else {
        selectedKeyword = nil
      }
      getRecordList(
        endPoint: .getRecentRecordList(
          DTO.GetRecentRecordListRequest(
            keywords: selectedKeyword,
            cursorId: cursorId,
            size: 15
          )
        ),
        response: DTO.GetRecentRecordListResponse.self
      )
    case .userProfile:
      guard let userId else { return }
      getRecordList(
        endPoint: .getUserRecordList(
          DTO.GetUserRecordListRequest(
            otherUserId: userId,
            cursorId: 0,
            size: 100
          )
        ),
        response: DTO.GetUserRecordListResponse.self
      )
    case .bookmarked:
      getRecordList(
        endPoint: .getBookmarkedRecordList(
          DTO.GetBookmarkedListRequest(
            cursorId: 0,
            size: 100
          )
        ),
        response: DTO.GetBookmarkedListResponse.self
      )
    default: return
    }
  }

  private func getRecordList<T: Codable>(
    endPoint: APITarget.Records,
    response: T.Type
  ) {
    guard !isFetching else { return }
    isFetching = true
    apiProvider.requestResponsable(
      endPoint,
      response
    ) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        processResponse(response: response)
      case .failure(_):
        self.feedList = []
        self.onFeedListUpdate?(0)
      }
    }
  }

  private func processResponse<T: Codable> (response: T) {
    if let allRecordListResponse = response as? DTO.RecordList {
      /// 전체 레코드 랜덤 조회
      print("@Process - \(#function)")
      updateFeedList(allRecordListResponse.feeds)
    } else if let followRecordListResponse = response as? DTO.GetFollowingRecordListResponse {
      /// 팔로잉 레코드 조회
      updateFeedList(followRecordListResponse.feeds)
      hasNext = followRecordListResponse.hasNext
      cursorId = followRecordListResponse.nextCursor
    } else if let famousRecordListResponse = response as? DTO.GetFamousRecordListResponse {
      /// 인기 레코드 조회 - n번째 게시물 클릭 가능
      var newFeeds: [Feed] = []
      if pageNumber == 0 {
        if let index = famousRecordListResponse.feeds.firstIndex(where: { $0.id == currentId }) {
          newFeeds = Array(famousRecordListResponse.feeds[index...])
        }
      } else {
        newFeeds = famousRecordListResponse.feeds
      }
      updateFeedList(newFeeds)
      hasNext = famousRecordListResponse.hasNext
      pageNumber += 1
    } else if let recentRecordListResponse = response as? DTO.GetRecentRecordListResponse {
      /// 최신 레코드 조회
      var newFeeds: [Feed] = []
      if cursorId == 0 {
        if let index = recentRecordListResponse.feeds.firstIndex(where: { $0.id == currentId }) {
          newFeeds = Array(recentRecordListResponse.feeds[index...])
        }
      } else {
        newFeeds = recentRecordListResponse.feeds
      }
      updateFeedList(newFeeds)
      hasNext = recentRecordListResponse.hasNext
      cursorId = recentRecordListResponse.nextCursor
    } else if let userProfileRecordListResponse = response as? DTO.GetUserRecordListResponse {
      /// 유저 프로필 레코드 조회
      guard let currentId else { return }
      if let index = userProfileRecordListResponse.feeds.firstIndex(where: { $0.id == currentId }) {
        let newFeeds = Array(userProfileRecordListResponse.feeds[index...])
        updateFeedList(newFeeds)
      }
    } else if let bookmarkedRecordListResponse = response as? DTO.GetBookmarkedListResponse {
      /// 유저 북마크 레코드 조회
      guard let currentId, hasNext else { return }
      if let index = bookmarkedRecordListResponse.feeds.firstIndex(where: { $0.id == currentId }) {
        let newFeeds = Array(bookmarkedRecordListResponse.feeds[index...])
        self.hasNext = bookmarkedRecordListResponse.hasNext
        updateFeedList(newFeeds)
      }
    }
  }

  private func updateFeedList(_ newFeeds: [Feed]) {
    cacheVideos(feeds: newFeeds) { [weak self] feed in
      guard let self else { return }
      print("@Cached - \(feed)")
      self.feedList += feed
      self.onFeedListUpdate?(feed.count)
    }
  }

  func cacheVideos(
    feeds: [Feed],
    completion: @escaping ([Feed]) -> Void) {
      let dispatchGroup = DispatchGroup()
      var cachedFeeds: [Feed] = []
      for feed in feeds {
        dispatchGroup.enter()
        VideoCacheManager.shared.downloadAndCacheURL(url: URL(string: feed.videoLink)!) { url in
          guard url != nil else {
            dispatchGroup.leave()
            return
          }
          let cachedFeed = Feed(
            id: feed.id,
            userId: feed.userId,
            location: feed.location,
            nickname: feed.nickname,
            description: feed.description,
            bookmarkCount: feed.bookmarkCount,
            isBookmarked: feed.isMine,
            videoLink: String(describing: url!),
            thumbnailLink: feed.thumbnailLink,
            isMine: feed.isMine
          )
          cachedFeeds.append(cachedFeed)
          dispatchGroup.leave()
        }
      }
      dispatchGroup.notify(queue: .main) {
        completion(cachedFeeds)
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
