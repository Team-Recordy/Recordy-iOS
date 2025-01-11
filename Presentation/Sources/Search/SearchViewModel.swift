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
  
  func getSearchResults(query: String) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Search>()
    let request = DTO.GetSearchRequest(query: query)
    self.filteredSearchResults = []
    
    apiProvider.requestResponsable(.getSearch(request), DTO.GetSearchResponse.self) { [weak self] result in
      guard let self = self else { return }
      isFetching = false
      switch result {
      case .success(let response):
        searchResults = response.map { result in
          SearchResult(
            id: result.id,
            type: result.type,
            address: result.address,
            name: result.name
          )
        }
        filteredPlaceIDs = Set(self.searchResults.map { $0.id })
        let group = DispatchGroup()
        
        for placeId in self.filteredPlaceIDs {
          group.enter()
          self.getPlace(placeId: placeId) { place in
            DispatchQueue.main.async {
              if let place = place {
                self.filteredSearchResults.append(place)
              }
            }
            group.leave()
          }
        }
        group.notify(queue: .main) {
          self.onCompleteExhibitionsUpdated?()
        }
        
      case .failure(let error):
        print("Error fetching near places: \(error)")
      }
    }
  }
  
  func getPlace(placeId: Int, completion: @escaping (Place?) -> Void) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Places>()
    
    apiProvider.requestResponsable(.getPlaceList(id: placeId), DTO.GetPlaceResponse.self) { [weak self] result in
      guard let self = self else { return }
      isFetching = false
      switch result {
      case .success(let response):
        var place = Place(
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
        self.getExhibitionList(placeId: placeId) { exhibitions in
          place.exhibitionList = exhibitions
          completion(place)
        }
      case .failure(let error):
        print("Error fetching exhibitions: \(error)")
        completion(nil)
      }
    }
  }
  
  func getExhibitionList(placeId: Int, completion: @escaping ([Exhibition]) -> Void) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Exhibitions>()
    let request = DTO.GetExhibitionListRequest(
      placeId: placeId
    )
    
    apiProvider.requestResponsable(.getExhibitionList(request), [DTO.GetExhibitionListResponse].self) { [weak self] result in
      guard let self = self else { return }
      isFetching = false
      switch result {
      case .success(let response):
        let exhibitions = response.map { exhibition in
          Exhibition(
            id: exhibition.id,
            name: exhibition.name,
            startDate: exhibition.startDate,
            endDate: exhibition.endDate,
            isFree: exhibition.isFree
          )
        }
        completion(exhibitions)
      case .failure(let error):
        print("Error fetching exhibitions: \(error)")
      }
    }
  }
}
