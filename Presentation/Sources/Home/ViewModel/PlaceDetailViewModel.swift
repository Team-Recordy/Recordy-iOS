//
//  PlaceDetailViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Common

public enum FilterType {
  case all
  case free
  case endSoon
}

public enum PlaceDetailControlType: String {
  case exhibitionList = "전시 리스트"
  case reviewFeed = "후기 영상"
}

public class PlaceDetailViewModel {
  var onControlTypeChanged: ((PlaceDetailControlType) -> Void)?
  var onFilterChanged: ((ChipState, ChipState, ChipState) -> Void)?
  
  private(set) var currentControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
      onControlTypeChanged?(currentControlType)
    }
  }
  
  private(set) var allFilterState: ChipState = .active
  private(set) var freeFilterState: ChipState = .inactive
  private(set) var endSoonFilterState: ChipState = .inactive
  
  public init() {}
  
  func updateControlType(to type: PlaceDetailControlType) {
    currentControlType = type
  }
  
  func updateFilterState(selected: FilterType) {
    allFilterState = (selected == .all) ? .active : .inactive
    freeFilterState = (selected == .free) ? .active : .inactive
    endSoonFilterState = (selected == .endSoon) ? .active : .inactive
    
    onFilterChanged?(allFilterState, freeFilterState, endSoonFilterState)
  }
}
