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
  
  var hasNext = true
  var isFetching = false
  
  func getSearchResults(query: String) {
    isFetching = true
    let apiProvider = APIProvider<APITarget.Search>()
    let request = DTO.GetSearchRequest(
      query: query
    )
    
    apiProvider.requestResponsable(.getSearch(request), DTO.GetSearchResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetching = false
      switch result {
      case .success(let response):
        self.searchResults = response.map { result in
          SearchResult(
            id: result.id,
            type: result.type,
            address: result.address,
            name: result.name
          )
        }
        print("🚨검색 결과: \(searchResults)🚨")
      case .failure(let error):
        print("Error fetching near places: \(error)")
      }
    }
  }
}
