//
//  OverviewViewModel.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

enum RecordType {
  case near
  case place(Int)
}

public enum LocationState {
  case active
  case inactive
  
  var buttonImage: UIImage {
    switch self {
    case .active:
      return CommonAsset.locationActive.image
    case .inactive:
      return CommonAsset.locationInactive.image
    }
  }
}

public class OverviewViewModel {
  
  var nearRecords: [Place] = []
  var placeRecords: [Feed] = []
//  var cursorId: Int?
  var hasNext = true
  var isFetching = false
  var onNearRecordsUpdated: (() -> Void)?
  var onPlaceRecordsUpdated: (() -> Void)?
  var onLocationStateChanged: ((LocationState) -> Void)?
  
//  init(cursorId: Int? = nil) {
//    self.cursorId = cursorId
//  }
  
  func recordListCase(type: RecordType) {
    guard !isFetching else { return }
    guard hasNext else { return }
    
    switch type {
    case .near:
      getNearPlaceList()
    case .place(let placeId):
      getPlaceRecordList(placeId: placeId)
    }
  }
  
  func getNearPlaceList() {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Places>()
    let request = DTO.GetNearPlaceListRequest(
      number: 0,
      size: 10,
      latitude: 37.57858694484229,
      longitude: 126.98009796814407,
      distance: 400
    )
    
    apiProvider.requestResponsable(.getNearPlaceList(request), DTO.GetNearPlaceListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        self.hasNext = response.hasNext
        self.nearRecords.append(contentsOf: response.content.map { place in
          Place(
            id: place.id,
            name: place.name,
            address: place.address,
            platformId: place.platformId,
            locationId: place.location.id,
            longitude: place.location.longitude,
            latitude: place.location.latitude,
            exhibitionSize: place.exhibitionSize,
            recordSize: place.recordSize
          )
        })
        self.onNearRecordsUpdated?()
      case .failure(let error):
        print("Error fetching near places: \(error)")
      }
    }
  }
  
  func getPlaceRecordList(placeId: Int) {
    
    isFetching = true
    let apiProvider = APIProvider<APITarget.Records>()
    
    let request = DTO.GetPlaceRecordListRequest(
      placeId: placeId,
      size: 10
    )
    
    apiProvider.requestResponsable(.getPlaceRecordList(request), DTO.GetPlaceRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
//        self.cursorId = response.nextCursor
        self.hasNext = response.hasNext
        self.placeRecords.append(contentsOf: response.content.map { content in
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
        })
        
        self.onPlaceRecordsUpdated?()
      case .failure(let error):
        print("Error fetching records for placeId \(placeId): \(error)")
      }
    }
  }
  
  private(set) var locationState: LocationState = .inactive {
    didSet {
      onLocationStateChanged?(locationState)
    }
  }
  
  func updateLocationState() {
    locationState = (locationState == .active) ? .inactive : .active
  }
}
