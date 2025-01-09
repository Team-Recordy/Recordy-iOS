//
//  PlaceDetailViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Common
import Core
import Foundation

public enum FilterType: Int {
  case all = 0
  case free = 1
  case endSoon = 2
}

public enum PlaceDetailControlType: String {
  case exhibitionList = "전시 리스트"
  case reviewFeed = "후기 영상"
}

public class PlaceDetailViewModel {
  var onControlTypeChanged: ((PlaceDetailControlType) -> Void)?
  var onFilterChanged: ((ChipState, ChipState, ChipState) -> Void)?
  var onExhibitionsUpdated: (() -> Void)?
  var onFeedsUpdated:(() -> Void)?
  
  var selectedPlace: [Place] = []
  var exhibitions: [Exhibition] = []
  var reviewFeedList: [Feed] = []
  var allExhibitions: [Exhibition] = []
  var freeExhibitions: [Exhibition] = []
  var endSoonExhibitions: [Exhibition] = []
  // isFree가 false인 데이터가 대부분이라 필터링 잘 되는지 확인 위해 MockData 활용
  var test: [Exhibition] = [Core.Exhibition(id: 326, name: "장인, 세상을 이롭게 하다", startDate: "2021-07-16", endDate: "2022-12-31", isFree: true), Core.Exhibition(id: 327, name: "자수, 꽃이 피다", startDate: "2021-07-16", endDate: "2025-12-31", isFree: false)]
  
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
  
  public init(
    place: Place,
    reviewFeeds: [Feed]
  ) {
    selectedPlace = [place]
    reviewFeedList = reviewFeeds
    onFeedsUpdated?()
    initFilterState()
  }
  
  private func categorizeExhibitions() {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.timeZone = TimeZone.current
      
      allExhibitions = test
      freeExhibitions = test.filter { $0.isFree }
      
      endSoonExhibitions = test
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
}
