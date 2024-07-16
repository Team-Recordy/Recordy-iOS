//
//  MyRecordViewModel.swift
//  Presentation
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Common

import Core

class MyRecordViewModel {
  var records: Bindable<[FeedModel]> = Bindable([])
  var isEmpty: Bindable<Bool> = Bindable(true)
  
  func fetchRecords() {
    // Example records, you can replace this with your actual data fetching logic
    let fetchedRecords: [FeedModel] = [
      FeedModel(
        id: 1,
        thumbnail: "thumbnail1.jpg",
        isbookmarked: true,
        location: "Seoul",
        video: nil,
        keywords: [],
        nickname: "User1",
        description: "Description 1",
        bookmarkCount: 10
      ),
      FeedModel(
        id: 2,
        thumbnail: "thumbnail2.jpg",
        isbookmarked: false,
        location: "Busan",
        video: nil,
        keywords: [],
        nickname: "User2",
        description: "Description 2",
        bookmarkCount: 20
      ),
      FeedModel(
        id: 3,
        thumbnail: "thumbnail3.jpg",
        isbookmarked: true,
        location: "Incheon",
        video: nil,
        keywords: [],
        nickname: "User3",
        description: "Description 3",
        bookmarkCount: 5
      ),
      FeedModel(
        id: 4,
        thumbnail: "thumbnail4.jpg",
        isbookmarked: false,
        location: "Daegu",
        video: nil,
        keywords: [],
        nickname: "User4",
        description: "Description 4",
        bookmarkCount: 8
      )
    ]
    
    records.value = fetchedRecords
    isEmpty.value = fetchedRecords.isEmpty
  }
}
