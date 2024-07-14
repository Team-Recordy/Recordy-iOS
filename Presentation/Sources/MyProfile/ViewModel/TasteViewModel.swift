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
    //데이터 로직!! 들어갈 자리임
    let fetchedData: [TasteData] = []
    tasteData.value = fetchedData
    isEmpty.value = fetchedData.isEmpty
  }
}

