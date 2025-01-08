//
//  PlaceDetailViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Common
import Core

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
  
  var selectedPlace: [Place] = []
  var exhibitions: [Exhibition] = [] {
    didSet {
      onExhibitionsUpdated?()
    }
  }
  var freeExhibitions: [Exhibition] = []
  var ongoingExhibitions: [Exhibition] = []
  
  var hasNext = true
  var isFetching = false
  
  private(set) var currentControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
      onControlTypeChanged?(currentControlType)
    }
  }
  
  private(set) var allFilterState: ChipState = .active
  private(set) var freeFilterState: ChipState = .inactive
  private(set) var endSoonFilterState: ChipState = .inactive
  
  public init(place: Place) {
    selectedPlace.append(place)
    initFilterState()
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
            isFree: exhibition.isFree
          )
        }
      case .failure(let error):
        print("Error fetching exhibitions: \(error)")
      }
    }
  }
  
  func updateControlType(to type: PlaceDetailControlType) {
    currentControlType = type
  }
  
  func updateFilterState(selected: FilterType) {
    allFilterState = (selected == .all) ? .active : .inactive
    freeFilterState = (selected == .free) ? .active : .inactive
    endSoonFilterState = (selected == .endSoon) ? .active : .inactive
    
    onFilterChanged?(allFilterState, freeFilterState, endSoonFilterState)
  }
  
  private func initFilterState() {
    onFilterChanged?(allFilterState, freeFilterState, endSoonFilterState)
  }
}
