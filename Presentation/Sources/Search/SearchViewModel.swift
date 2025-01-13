//
//  SearchViewModel.swift
//  Presentation
//
//  Created by Chandrala on 1/10/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core

public class SearchViewModel {
  var searchResults: [SearchResult] = []
  var filteredPlaceIDs: Set<Int> = []
  var filteredSearchResults: [Place] = []
  
  var onCompleteExhibitionsUpdated: (() -> Void)?
  
  private var hasNext = true
  private var isFetching = false
  
  func getPlace(placeId: Int, completion: @escaping (Place?) -> Void) {
    let apiProvider = APIProvider<APITarget.Places>()
    apiProvider.requestResponsable(.getPlaceList(id: placeId), DTO.GetPlaceResponse.self) { result in
      switch result {
      case .success(let response):
        let place = Place(
          id: response.id,
          name: response.name,
          address: response.address,
          platformId: response.platformId,
          locationId: response.location.id,
          longitude: response.location.longitude,
          latitude: response.location.latitude,
          exhibitionSize: response.exhibitionSize,
          recordSize: response.recordSize
        )
        completion(place)
      case .failure(let error):
        print("Error fetching place: \(error)")
        completion(nil)
      }
    }
  }
  
  func getExhibitionList(placeId: Int, completion: @escaping ([Exhibition]) -> Void) {
    let apiProvider = APIProvider<APITarget.Exhibitions>()
    let request = DTO.GetExhibitionListRequest(placeId: placeId)
    apiProvider.requestResponsable(.getExhibitionList(request), [DTO.GetExhibitionListResponse].self) { result in
      switch result {
      case .success(let response):
        let exhibitions = response.map {
          Exhibition(id: $0.id, name: $0.name, startDate: $0.startDate, endDate: $0.endDate, isFree: $0.isFree)
        }
        completion(exhibitions)
      case .failure(let error):
        print("Error fetching exhibitions: \(error)")
        completion([])
      }
    }
  }
  
  func getPlaceRecordList(placeId: Int, recordSize: Int, completion: @escaping ([Feed]) -> Void) {
    let apiProvider = APIProvider<APITarget.Records>()
    let request = DTO.GetPlaceRecordListRequest(placeId: placeId, size: recordSize)
    apiProvider.requestResponsable(.getPlaceRecordList(request), DTO.GetPlaceRecordListResponse.self) { result in
      switch result {
      case .success(let response):
        let feeds = response.content.map {
          Feed(
            id: $0.id,
            videoLink: $0.fileUrl.videoUrl,
            thumbnailLink: $0.fileUrl.thumbnailUrl,
            description: $0.content,
            exhibitionName: $0.exhibitionName,
            placeId: $0.placeId,
            placeName: $0.placeName,
            uploaderId: $0.uploaderId,
            uploaderNickname: $0.uploaderNickname,
            bookmarkCount: $0.bookmarkCount,
            isMine: $0.isMine,
            isBookmarked: $0.isBookmarked
          )
        }
        completion(feeds)
      case .failure(let error):
        print("Error fetching records: \(error)")
        completion([])
      }
    }
  }
  
  func getPlaceWithExhibitions(placeId: Int, completion: @escaping (Place?) -> Void) {
    getPlace(placeId: placeId) { place in
      guard var place = place else {
        completion(nil)
        return
      }
      self.getExhibitionList(placeId: placeId) { exhibitions in
        place.exhibitionList = exhibitions
        completion(place)
      }
    }
  }
  
  func getSearchResultsWithDetails(query: String) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Search>()
    let request = DTO.GetSearchRequest(query: query)
    self.filteredSearchResults = []
    
    apiProvider.requestResponsable(.getSearch(request), DTO.GetSearchResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        self.searchResults = response.map {
          SearchResult(id: $0.id, type: $0.type, address: $0.address, name: $0.name)
        }
        filteredPlaceIDs = Set(self.searchResults.map { $0.id })
        
        let group = DispatchGroup()
        
        for placeId in self.filteredPlaceIDs {
          group.enter()
          self.getPlaceWithExhibitions(placeId: placeId) { place in
            if let place = place {
              self.filteredSearchResults.append(place)
            }
            group.leave()
          }
        }
        
        group.notify(queue: .main) {
          self.onCompleteExhibitionsUpdated?()
        }
        
      case .failure(let error):
        print("Error fetching search results: \(error)")
      }
    }
  }
  
  func getPlaceWithRecords(placeId: Int, recordSize: Int, completion: @escaping (Place?) -> Void) {
    getPlace(placeId: placeId) { place in
      guard var place = place else {
        completion(nil)
        return
      }
      self.getPlaceRecordList(placeId: placeId, recordSize: recordSize) { records in
        place.recordList = records
        completion(place)
      }
    }
  }
}
