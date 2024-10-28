//
//  PlaceDetailViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

public class PlaceDetailViewModel {
  var onControlTypeChanged: ((PlaceDetailControlType) -> Void)?
  
  private(set) var currentControlType: PlaceDetailControlType = .exhibitionList {
    didSet {
       onControlTypeChanged?(currentControlType)
    }
  }
  
  public init(initialControlType: PlaceDetailControlType = .exhibitionList) {
    self.currentControlType = initialControlType
  }
  
  func updateControlType(to type: PlaceDetailControlType) {
    currentControlType = type
  }
}
