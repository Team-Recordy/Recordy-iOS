//
//  PlaceDetailViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
import Foundation
import MapKit

import Common
import Core


public enum FilterType: Int {
  case all = 0
  case free = 1
  case endSoon = 2
}

public enum MapType {
  case kakao
  case naver
  case google
  case apple
}

public enum PlaceDetailControlType: String {
  case exhibitionList = "전시 리스트"
  case reviewFeed = "후기 영상"
}

public class PlaceDetailViewModel {
  var selectedPlace: [Place] = []
  var exhibitions: [Exhibition] = []
  var reviewFeedList: [Feed] = []
  var allExhibitions: [Exhibition] = []
  var freeExhibitions: [Exhibition] = []
  var endSoonExhibitions: [Exhibition] = []
  
  var onControlTypeChanged: ((PlaceDetailControlType) -> Void)?
  var onFilterChanged: ((ChipState, ChipState, ChipState) -> Void)?
  var onExhibitionsUpdated: (() -> Void)?
  var onFeedsUpdated:(() -> Void)?
  var onBookmarkUpdated: ((Int) -> Void)?
  
  var hasNext = true
  var isFetching = false
  private(set) var currentControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
      onControlTypeChanged?(currentControlType)
    }
  }
  
  private(set) var currentFilterType: FilterType = .all
  
  private(set) var allFilterState: ChipState = .active
  private(set) var freeFilterState: ChipState = .inactive
  private(set) var endSoonFilterState: ChipState = .inactive
  
  public init(place: Place) {
    selectedPlace = [place]
    reviewFeedList = place.recordList
    onFeedsUpdated?()
    initFilterState()
  }
  
  private func categorizeExhibitions() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    
    allExhibitions = exhibitions
    freeExhibitions = exhibitions.filter { $0.isFree }
    endSoonExhibitions = exhibitions
      .filter { exhibition in
        let endDate = formatter.date(from: exhibition.endDate) ?? Date.distantPast
        return endDate > Date() // 종료일이 현재 날짜 이후인 항목만 포함
      }
      .sorted { first, second in
        let firstEndDate = formatter.date(from: first.endDate) ?? Date.distantFuture
        let secondEndDate = formatter.date(from: second.endDate) ?? Date.distantFuture
        return firstEndDate < secondEndDate // 종료일이 빠른 순으로 정렬
      }
  }
  
  var filteredExhibitions: [Exhibition] {
    switch currentFilterType {
    case .all:
      return allExhibitions
    case .free:
      return freeExhibitions
    case .endSoon:
      return endSoonExhibitions
    }
  }
  
  func getExhibitionList(placeId: Int) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Exhibitions>()
    let request = DTO.GetExhibitionListRequest(
      placeId: placeId
    )
    
    apiProvider.requestResponsable(.getExhibitionList(request), [DTO.GetExhibitionListResponse].self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.exhibitions = response.map { exhibition in
          Exhibition(
            id: exhibition.id,
            name: exhibition.name,
            startDate: exhibition.startDate,
            endDate: exhibition.endDate,
            isFree: exhibition.isFree
          )
        }
      case .failure(let error):
        print("Error fetching exhibitions: \(error)")
      }
      categorizeExhibitions()
      self.onExhibitionsUpdated?()
    }
  }
  
  func getReviewFeedList(placeId: Int, recordSize: Int) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetPlaceRecordListRequest(
      placeId: placeId,
      size: recordSize
    )
    
    apiProvider.requestResponsable(.getPlaceRecordList(request), DTO.GetPlaceRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        let fetchedFeeds = response.content.map { content in
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
        
        if let index = self.selectedPlace.firstIndex(where: { $0.id == placeId }) {
          self.selectedPlace[index].recordList = fetchedFeeds
        }
        
        self.reviewFeedList = fetchedFeeds
        self.onFeedsUpdated?()
        
      case .failure(let error):
        print("Error fetching review feed list: \(error)")
      }
    }
  }
  
  func postBookmark(index: Int, completion: (() -> Void)? = nil) {
    let bookmarkProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: reviewFeedList[index].id)
    
    bookmarkProvider.justRequest(.postBookmark(request)) { result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.reviewFeedList[index].isBookmarked.toggle()
          self.onBookmarkUpdated?(index)
          
          completion?()
        }
      case .failure(let error):
        print("북마크 요청 실패: \(error)")
      }
    }
  }
  
  func updateControlType(to type: PlaceDetailControlType) {
    currentControlType = type
  }
  
  func updateFilterState(selected: FilterType) {
    allFilterState = .inactive
    freeFilterState = .inactive
    endSoonFilterState = .inactive
    
    switch selected {
    case .all:
      allFilterState = .active
    case .free:
      freeFilterState = .active
    case .endSoon:
      endSoonFilterState = .active
    }
    
    currentFilterType = selected
    
    onFilterChanged?(allFilterState, freeFilterState, endSoonFilterState)
    onExhibitionsUpdated?()
  }
  
  private func initFilterState() {
    onFilterChanged?(allFilterState, freeFilterState, endSoonFilterState)
  }
  
  public func openMap(type: MapType) {
    guard let place = selectedPlace.first,
          let userLat = LocationManager.shared.currentLatitude,
          let userLong = LocationManager.shared.currentLongitude,
          let placeLat = selectedPlace.first?.latitude,
          let placeLong = selectedPlace.first?.longitude else { return }
    
    switch type {
    case .kakao:
      guard let url = URL(string: "kakaomap://route?sp=\(userLat),\(userLong)&ep=\(placeLat),\(placeLong)&by=PUBLICTRANSIT") else { return }
      guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id304608425") else { return }
      
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.open(appStoreUrl)
      }
      
    case .naver:
      guard let url = URL(string: "nmap://route/public?slat=37.4640070&slng=126.9522394&sname=내 위치&dlat=37.5209436&dlng=127.1230074&dname=\(place.name)&appname=com.viskit-iOS") else { return }
      guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }
      
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.open(appStoreURL)
      }
      
    case .google:
      guard let url = URL(string: "comgooglemaps://?saddr=\(userLat),\(userLong)&daddr=\(placeLat),\(placeLong)&directionsmode=transit") else { return }
      guard let appStoreURL = URL(string: "https://apps.apple.com/app/id585027354") else { return }
      
      if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.open(appStoreURL)
      }
      
    case .apple:
      guard let url = URL(string: "maps://?saddr=\(userLat),\(userLong)&daddr=\(placeLat),\(placeLong)&dirflg=r") else { return }
      guard let appStoreURL = URL(string: "https://apps.apple.com/app/apple-maps/id915056765") else { return }
      
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.open(appStoreURL)
      }
    }
  }
}
