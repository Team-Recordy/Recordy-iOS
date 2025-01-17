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
  
  var hasNext = true
  var isFetching = false
  private let userLatitude: Double
  private let userLongitude: Double
  private(set) var currentControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
      onControlTypeChanged?(currentControlType)
    }
  }
  
  private(set) var currentFilterType: FilterType = .all
  
  private(set) var allFilterState: ChipState = .active
  private(set) var freeFilterState: ChipState = .inactive
  private(set) var endSoonFilterState: ChipState = .inactive
  
  public init(
    place: Place,
    latitude: Double,
    longitude: Double
  ) {
    selectedPlace = [place]
    reviewFeedList = place.recordList
    userLatitude = latitude
    userLongitude = longitude
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
  
  func postBookmark(feed: Feed, completion: ((Result<Void, Error>) -> Void)? = nil) {
    let apiProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: feed.id)
    
    apiProvider.justRequest(.postBookmark(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        if let recordIndex = self.reviewFeedList.firstIndex(where: { $0.id == feed.id }) {
          self.reviewFeedList[recordIndex].isBookmarked = !feed.isBookmarked
          self.onFeedsUpdated?()
        }
        completion?(.success(()))
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
        completion?(.failure(error))
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
  
  public func openMap(type: MapType, openInWebView: @escaping (String) -> Void) {
    guard let place = selectedPlace.first,
          let placeLatitude = selectedPlace.first?.latitude,
          let placeLongitude = selectedPlace.first?.longitude,
          let name = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return
    }
    
    switch type {
    case .kakao:
      let appURL = "kakaomap://route?ep=\(userLatitude),\(userLatitude)&name=\(name)&by=car"
      let webURL = "https://map.kakao.com/link/to/\(name),\(placeLatitude),\(placeLongitude)"
      WebViewManager.openURL(appURLString: appURL, webURLString: webURL, openInWebView: openInWebView)
    case .naver:
      let appURL = "nmap://route?slat=\(userLatitude)&slng=\(userLongitude)&dlat=\(selectedPlace.first?.latitude)&dlng=\(selectedPlace.first?.longitude)&mode=transit"
      print("🚨\("nmap://route?slat=\(userLatitude)&slng=\(userLongitude)&dlat=\(placeLatitude)&dlng=\(placeLongitude)&mode=transit")🚨")
      let webURL = "https://map.naver.com/v5/directions/\(userLatitude),\(userLongitude)/\(placeLatitude),\(placeLongitude)/transit"
      WebViewManager.openURL(appURLString: appURL, webURLString: webURL, openInWebView: openInWebView)
    case .google:
      let appURL = "comgooglemaps://?q=\(userLatitude),\(userLongitude)"
      let webURL = "https://www.google.com/maps?q=\(placeLatitude),\(placeLongitude)"
      WebViewManager.openURL(appURLString: appURL, webURLString: webURL, openInWebView: openInWebView)
    }
  }
}
