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
  case exhibition(Int)
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
  var nearPlaces: [Place] = []
  
  var hasNext = true
  var isFetching = false
  
  private let locationManager = LocationManager()
  
  private(set) var locationState: LocationState = .inactive {
    didSet { 
      onLocationStateChanged?(locationState)
    }
  }
  
  var onNearPlacesUpdated: (() -> Void)?
  var onPlaceRecordsUpdated: (() -> Void)?
  var onLocationStateChanged: ((LocationState) -> Void)?
  
  init() {
    updateLocationStateFromAuthorizationStatus()
  }
  
  private func updateLocationStateFromAuthorizationStatus() {
    switch locationManager.currentAuthorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      locationState = .active
    case .denied, .restricted, .notDetermined:
      locationState = .inactive
    default:
      locationState = .inactive
    }
  }
  
  func updateLocation() {
    locationState = .active
  }
  
  func getNearPlaceList() {
    let latitude = LocationManager.shared.currentLatitude ?? 37.33264473613715
    let longitude = LocationManager.shared.currentLongitude ?? 127.11934019700556
    
    isFetching = true
    let apiProvider = APIProvider<APITarget.Places>()
    let request = DTO.GetNearPlaceListRequest(
      number: 0,
      size: 100,
      latitude: latitude,
      longitude: longitude,
      distance: 10000000
    )
    
    apiProvider.requestResponsable(.getNearPlaceList(request), DTO.GetNearPlaceListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        self.hasNext = response.hasNext
        self.nearPlaces = response.content.map { place in
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
        }
        self.onNearPlacesUpdated?()
        
      case .failure(let error):
        print("Error fetching near places: \(error)")
      }
    }
  }
  
  func getPlaceRecordList(placeId: Int, recordSize: Int, completion: @escaping () -> Void) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetPlaceRecordListRequest(
      placeId: placeId,
      size: recordSize
    )
    
    apiProvider.requestResponsable(.getPlaceRecordList(request), DTO.GetPlaceRecordListResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        if let index = self.nearPlaces.firstIndex(where: { $0.id == placeId }) {
          self.nearPlaces[index].recordList = response.content.map { content in
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
          }
        }
        
      case .failure(let error):
        print("Error fetching records for placeId \(placeId): \(error)")
      }
      completion()
    }
  }
  
  func postBookmark(feed: Feed, completion: ((Result<Void, Error>) -> Void)? = nil) {
    let apiProvider = APIProvider<APITarget.Bookmarks>()
    let request = DTO.PostBookmarkRequest(recordId: feed.id)
    
    apiProvider.justRequest(.postBookmark(request)) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        if let placeIndex = self.nearPlaces.firstIndex(where: { $0.id == feed.placeId }),
           let recordIndex = self.nearPlaces[placeIndex].recordList.firstIndex(where: { $0.id == feed.id }) {
          self.nearPlaces[placeIndex].recordList[recordIndex].isBookmarked = !feed.isBookmarked
        }
        completion?(.success(()))
      case .failure(let error):
        print("Failed to update bookmark: \(error)")
        completion?(.failure(error))
      }
    }
  }
}
