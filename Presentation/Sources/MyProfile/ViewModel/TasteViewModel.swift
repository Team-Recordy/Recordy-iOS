//
//  TasteViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import UIKit

import Core
import Common

enum TasteCase {
  case large
  case medium
  case small
  
  var title: UIFont {
    switch self {
    case .large:
      RecordyFont.keyword1.font
    case .medium:
      RecordyFont.keyword2.font
    case .small:
      RecordyFont.keyword3.font
    }
  }
  
  var subtitle: UIFont {
    switch self {
    case .large:
      RecordyFont.number1.font
    case .medium:
      RecordyFont.number2.font
    case .small:
      RecordyFont.number3.font
    }
  }
}

class TasteViewModel {
  var tasteData: Bindable<[TasteData]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchTasteData() {
    let fetchedData: [TasteData] = [
      TasteData(title: "집중하기 좋은", percentage: 66, type: .large),
      TasteData(title: "분위기 좋은", percentage: 22, type: .medium),
      TasteData(title: "클래식한", percentage: 10, type: .small)
    ]    
    tasteData.value = fetchedData
    isEmpty.value = fetchedData.isEmpty
  }
}

