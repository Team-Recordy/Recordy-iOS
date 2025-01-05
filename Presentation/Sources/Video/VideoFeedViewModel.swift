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
  let apiProvider = APIProvider<APITarget.Records>()
  var type: VideoFeedType
  var cursorId: Int?
  var currentId: Int?
  var userId: Int?
  var hasNext = true
  var pageNumber = 0
  var isFetching = false
  var isToggle = false
  var onFeedListUpdate: ((Int) -> ())?
  var isBookmarked: (() -> ())?
  
  init(
    type: VideoFeedType,
    currentId: Int? = nil,
    cursorId: Int? = nil,
    userId: Int? = nil
  ) {
    self.type = type
    self.currentId = currentId
    self.cursorId = cursorId
    self.userId = userId
    recordListCase()
  }
  
  // 필요없는 famous, recent case 삭제함
  func recordListCase(toggle: Bool? = nil) {
    guard !isFetching else { return }
    switch type {
    case .all:
      getPlaceRecordList(
        endPoint: .getRandomRecordList(DTO.GetRandomRecordListRequest(size: 15)),
        response: DTO.GetRandomRecordListResponse.self
      )
    case .following:
      guard let cursorId else { return }
      getPlaceRecordList(
        endPoint: .getFollowingRecordList(
          DTO.GetFollowingRecordListRequest(size: 15)
        ),
        response: DTO.GetFollowingRecordListResponse.self
      )
    case .userProfile:
      guard let userId else { return }
      getPlaceRecordList(
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
      getPlaceRecordList(
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
  
  private func getPlaceRecordList<T: Codable>(
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
  
  // Content -> Feed 타입 변환 해줬음
  private func processResponse<T: Codable>(response: T) {
    if let randomRecordListResponse = response as? DTO.GetRandomRecordListResponse {
      let feeds: [Feed] = randomRecordListResponse.content.map { content in
        Feed(
          id: content.id,
          userId: content.uploaderId,
          location: content.placeName,
          nickname: content.uploaderNickname,
          description: content.content,
          isBookmarked: content.isBookmarked,
          bookmarkCount: content.bookmarkCount,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          isMine: content.isMine
        )
      }
      updateFeedList(feeds)
    } else if let followingRecordListResponse = response as? DTO.GetFollowingRecordListResponse {
      /// 팔로잉 레코드 조회
      let feeds: [Feed] = followingRecordListResponse.content.map { content in
        Feed(
          id: content.id,
          userId: content.uploaderId,
          location: content.placeName,
          nickname: content.uploaderNickname,
          description: content.content,
          isBookmarked: content.isBookmarked,
          bookmarkCount: content.bookmarkCount,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          isMine: content.isMine
        )
      }
      updateFeedList(feeds)
      hasNext = followingRecordListResponse.hasNext
      cursorId = followingRecordListResponse.nextCursor
    } else if let userProfileRecordListResponse = response as? DTO.GetUserRecordListResponse {
      /// 유저 프로필 레코드 조회
      guard let currentId else { return }
      if let index = userProfileRecordListResponse.content.firstIndex(where: { $0.id == currentId }) {
        let feeds: [Feed] = userProfileRecordListResponse.content.map { content in
          Feed(
            id: content.id,
            userId: content.uploaderId,
            location: content.placeName,
            nickname: content.uploaderNickname,
            description: content.content,
            isBookmarked: content.isBookmarked,
            bookmarkCount: content.bookmarkCount,
            videoLink: content.fileUrl.videoUrl,
            thumbnailLink: content.fileUrl.thumbnailUrl,
            isMine: content.isMine
          )
        }
        updateFeedList(feeds)
      } else if let bookmarkedRecordListResponse = response as? DTO.GetBookmarkedListResponse {
        /// 유저 북마크 레코드 조회
        guard hasNext else { return }
        if let index = bookmarkedRecordListResponse.content.firstIndex(where: { $0.id == currentId }) {
          let newFeeds: [Feed] = Array(bookmarkedRecordListResponse.content[index...]).map { content in
            Feed(
              id: content.id,
              userId: content.uploaderId,
              location: content.placeName,
              nickname: content.uploaderNickname,
              description: content.content,
              isBookmarked: content.isBookmarked,
              bookmarkCount: content.bookmarkCount,
              videoLink: content.fileUrl.videoUrl,
              thumbnailLink: content.fileUrl.thumbnailUrl,
              isMine: content.isMine
            )
          }
          self.hasNext = bookmarkedRecordListResponse.hasNext
          updateFeedList(newFeeds)
        }
      }
    }
  }
    
    func updateFeedList(_ newFeeds: [Feed]) {
      cacheVideos(feeds: newFeeds) { [weak self] cachedFeeds in
        guard let self else { return }
        self.feedList += cachedFeeds
        self.onFeedListUpdate?(cachedFeeds.count)
      }
    }
    
    func cacheVideos(
      feeds: [Feed],
      completion: @escaping ([Feed]) -> Void
    ) {
      let dispatchGroup = DispatchGroup()
      var cachedFeeds: [Feed] = []
      
      for feed in feeds {
        dispatchGroup.enter()
        VideoCacheManager.shared.downloadAndCacheURL(url: URL(string: feed.videoLink)!) { url in
          guard let cachedUrl = url else {
            dispatchGroup.leave()
            return
          }
          let cachedFeed = Feed(
            id: feed.id,
            userId: feed.userId,
            location: feed.location,
            nickname: feed.nickname,
            description: feed.description,
            isBookmarked: feed.isBookmarked,
            bookmarkCount: feed.bookmarkCount,
            videoLink: String(describing: cachedUrl),
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
    
    //  func postIsFeedWatched(feed: Feed) {
    //    let request = DTO.IsRecordWatchedRequest(recordId: feed.id)
    //    apiProvider.justRequest(.isRecordWatched(request)) { result in
    //      switch result {
    //      case .success:
    //        print("@Log - success")
    //      case .failure(let failure):
    //        print(failure)
    //      }
    //    }
    //  }
    
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
      let bookmarkProvider = APIProvider<APITarget.Bookmarks>()
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
