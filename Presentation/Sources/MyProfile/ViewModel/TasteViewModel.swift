//
//  TasteViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core

class TasteViewModel {
  var tasteData: Bindable<[TasteData]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchTasteData() {
    let fetchedData: [TasteData] = [
      TasteData(title: "집중하기 좋은", percentage: 66),
      TasteData(title: "집중하기 좋은", percentage: 22),
      TasteData(title: "집중하기 좋은", percentage: 10)
    ]    
    tasteData.value = fetchedData
    isEmpty.value = fetchedData.isEmpty
  }
}

