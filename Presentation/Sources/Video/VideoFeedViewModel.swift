//
//  VideoFeedViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core

public enum VideoFeedType {
  case all
  case follow
  case place
  case mine
  case others
  case bookmarked
}

public enum VideoFeedType_new {
  case all // 전체 랜덤 영상
  case follow // 팔로우 하는 사람들 랜덤 영상
  case place // 장소 눌렀을 때 드는 영상
  case mine // 내 영상 userID = 내꺼
  case others // 그 사람 userID
  case bookmarked // 북마크된 영상
}

class VideoFeedViewModel {
  
  var feedList: [Feed] = []
  let apiProvider = APIProvider<APITarget.Records>()
  var type: VideoFeedType
  var cursorId: Int?
  var placeId: Int?
  var exhibitionId: Int?
  var userId: Int?
  var size: Int?
  var hasNext = true
  var pageNumber = 0
  var isFetching = false
  var onFeedListUpdate: ((Int) -> ())?
  var isBookmarked: (() -> ())?
  var newType: VideoFeedType = .all
  var isPlayed = false
  var feedUpdated = false
  
  init(
    type: VideoFeedType,
    placeId: Int? = nil,
    exhibitionId: Int? = nil,
    cursorId: Int? = nil,
    userId: Int? = nil
  ) {
    self.type = type
    self.placeId = placeId
    self.exhibitionId = exhibitionId
    self.cursorId = cursorId
    self.userId = userId
    recordListCase()
  }
  
  func play() {
    isPlayed = true
  }
  
  func toggle(from videoType: VideoFeedType) {
    isPlayed = false
    feedList.removeAll()
    type = videoType
    recordListCase()
  }
  
  func recordListCase() {
    guard !isFetching else { return }
    switch type {
    case .all:
      getPlaceRecordList(
        endPoint: .getRandomRecordList(DTO.GetRandomRecordListRequest(size: 15)),
        response: DTO.GetRandomRecordListResponse.self
      )
    case .follow:
      getPlaceRecordList(
        endPoint: .getFollowingRecordList(DTO.GetFollowingRecordListRequest(size: 15)),
        response: DTO.GetFollowingRecordListResponse.self
      )
    case .others:
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
            cursorId: cursorId ?? 0,
            size: 100
          )
        ),
        response: DTO.GetBookmarkedListResponse.self
      )
    case .place:
      guard let placeId else { return }
      getPlaceRecordList(
        endPoint: .getPlaceRecordList(
          DTO.GetPlaceRecordListRequest(placeId: placeId, size: 100)
        ),
        response: DTO.GetPlaceRecordListResponse.self
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
  
  private func processResponse<T: Codable>(response: T) {
    if let randomRecordListResponse = response as? DTO.GetRandomRecordListResponse {
      let feeds: [Feed] = randomRecordListResponse.records.map { content in
        Feed(
          id: content.id,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          description: content.content,
          exhibitionName: content.exhibitionName,
          placeId: content.placeId,
          placeName: content.placeName,
          uploaderId: content.uploaderId,
          uploaderNickname: content.uploaderNickname,
          bookmarkCount: content.bookmarkCount,
          isMine: content.isMine,
          isBookmarked: content.isBookmarked
        )
      }
      updateFeedList(feeds)
    }
    if let followingRecordListResponse = response as? DTO.GetFollowingRecordListResponse {
      /// 팔로잉 레코드 조회
      let feeds: [Feed] = followingRecordListResponse.map { content in
        Feed(
          id: content.id,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          description: content.content,
          exhibitionName: content.exhibitionName,
          placeId: content.placeId,
          placeName: content.placeName,
          uploaderId: content.uploaderId,
          uploaderNickname: content.uploaderNickname,
          bookmarkCount: content.bookmarkCount,
          isMine: content.isMine,
          isBookmarked: content.isBookmarked
        )
      }
      updateFeedList(feeds)
      //      hasNext = followingRecordListResponse.hasNext
      //      cursorId = followingRecordListResponse.nextCursor
    }
    else if let userProfileRecordListResponse = response as? DTO.GetUserRecordListResponse {
      /// 유저 프로필 레코드 조회
      guard let placeId else { return }
      var feeds: [Feed] = userProfileRecordListResponse.content.map { content in
        Feed(
          id: content.id,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          description: content.content,
          exhibitionName: content.exhibitionName,
          placeId: content.placeId,
          placeName: content.placeName,
          uploaderId: content.uploaderId,
          uploaderNickname: content.uploaderNickname,
          bookmarkCount: content.bookmarkCount,
          isMine: content.isMine,
          isBookmarked: content.isBookmarked
        )
      }
      if let index = userProfileRecordListResponse.content.firstIndex(where: { $0.id == placeId }) {
        feeds = Array(feeds[index...])
      }
      updateFeedList(feeds)
    }
    else if let bookmarkedRecordListResponse = response as? DTO.GetBookmarkedListResponse {
      guard hasNext else { return }
      
      let allFeeds: [Feed] = bookmarkedRecordListResponse.content.map { content in
        Feed(
          id: content.id,
          videoLink: content.fileUrl.videoUrl,
          thumbnailLink: content.fileUrl.thumbnailUrl,
          description: content.content,
          exhibitionName: content.exhibitionName,
          placeId: content.placeId,
          placeName: content.placeName,
          uploaderId: content.uploaderId,
          uploaderNickname: content.uploaderNickname,
          bookmarkCount: content.bookmarkCount,
          isMine: content.isMine,
          isBookmarked: content.isBookmarked
        )
      }
      if let selectedFeedId = self.exhibitionId,
         let selectedFeedIndex = allFeeds.firstIndex(where: { $0.id == selectedFeedId }) {
        let selectedFeed = allFeeds[selectedFeedIndex]
        var sortedFeeds = allFeeds
        sortedFeeds.remove(at: selectedFeedIndex)
        sortedFeeds.insert(selectedFeed, at: 0)
        updateFeedList(sortedFeeds)
      } else {
        updateFeedList(allFeeds)
      }
    }
    else if let overviewPlaceRecordListResponse = response as? DTO.GetPlaceRecordListResponse {
      guard hasNext else { return }
      if let index = overviewPlaceRecordListResponse.content.firstIndex(where: { $0.id == exhibitionId }) {
        let newFeeds: [Feed] = Array(overviewPlaceRecordListResponse.content[index...]).map { content in
          Feed(
            id: content.id,
            videoLink: content.fileUrl.videoUrl,
            thumbnailLink: content.fileUrl.thumbnailUrl,
            description: content.content,
            exhibitionName: content.exhibitionName,
            placeId: content.placeId,
            placeName: content.placeName,
            uploaderId: content.uploaderId,
            uploaderNickname: content.uploaderNickname,
            bookmarkCount: content.bookmarkCount,
            isMine: content.isMine,
            isBookmarked: content.isBookmarked
          )
        }
        self.hasNext = overviewPlaceRecordListResponse.hasNext
        updateFeedList(newFeeds)
        //        }
      }
    }
  }
  
  func getPlaceInFeed(placeId: Int, completion: @escaping (Place?) -> Void) {
    let apiProvider = APIProvider<APITarget.Places>()
    apiProvider.requestResponsable(.getPlaceList(id: placeId), DTO.GetPlaceResponse.self) { result in
      switch result {
      case .success(let response):
        let place = Place(
          id: response.id,
          name: response.name,
          address: response.address,
          platformId: response.platformId,
          locationId: response.location.id,
          longitude: response.location.longitude,
          latitude: response.location.latitude,
          exhibitionSize: response.exhibitionSize,
          recordSize: response.recordSize
        )
        completion(place)
      case .failure(let error):
        print("Error fetching place: \(error)")
        completion(nil)
      }
    }
  }
  
  func updateFeedList(_ newFeeds: [Feed]) {
    feedList += newFeeds
    feedUpdated = true
    onFeedListUpdate?(newFeeds.count)
    
    //    cacheVideos(feeds: newFeeds) { [weak self] cachedFeeds in
    //      guard let self else { return }
    //      self.feedList += cachedFeeds
    //      self.onFeedListUpdate?(cachedFeeds.count)
    //    }
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
          videoLink: feed.videoLink,
          thumbnailLink: feed.thumbnailLink,
          description: feed.description,
          exhibitionName: feed.exhibitionName,
          placeId: feed.placeId,
          placeName: feed.placeName,
          uploaderId: feed.uploaderId,
          uploaderNickname: feed.uploaderNickname,
          bookmarkCount: feed.bookmarkCount,
          isMine: feed.isMine,
          isBookmarked: feed.isBookmarked
        )
        cachedFeeds.append(cachedFeed)
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      completion(cachedFeeds)
    }
  }
  
  func bookmarkFeed(index: Int) {
    let isBookmarked = feedList[index].isBookmarked
    feedList[index].isBookmarked.toggle()
    feedList[index].bookmarkCount += isBookmarked ? -1 : 1
    let bookmarkProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: feedList[index].id)
    bookmarkProvider.justRequest(.postBookmark(request)) { _ in }
  }
}
