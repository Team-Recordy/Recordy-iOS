//
//  SearchPlaceViewModel.swift
//  Presentation
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation
import Combine

import Core

final class SearchPlaceViewModel {

  struct SearchedPlace {
    let id: Int
    let type: String
    let address: String
    let name: String
  }

  private let apiProvider = APIProvider<APITarget.Search>()
  @Published var searchText: String = ""
  @Published var searchedPlace: [SearchedPlace] = []
  private var cancellables = Set<AnyCancellable>()

  init() {
    $searchText
      .debounce(
        for: .milliseconds(200),
        scheduler: RunLoop.main
      )
      .sink { [weak self] text in
        guard !text.isEmpty else {
          self?.searchedPlace = []
          return
        }
        self?.fetchSearchedPlace()
      }
      .store(in: &cancellables)
  }

  func fetchSearchedPlace() {
    let request = DTO.GetSearchRequest(query: searchText)
    apiProvider.requestResponsable(
      .getSearch(request),
      DTO.GetSearchResponse.self
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let response):
        let responseData = response.map {
          SearchedPlace(
            id: $0.id,
            type: $0.type,
            address: $0.address,
            name: $0.name
          )
        }
        self.searchedPlace = responseData
      case .failure(let failure):
        self.searchedPlace = []
      }
    }
  }
  //  apiProvider.requestResponsable(
  //    endPoint,
  //    response
  //  ) { [weak self] result in
  //    guard let self = self else { return }
  //    self.isFetching = false
  //    switch result {
  //    case .success(let response):
  //      processResponse(response: response)
  //    case .failure(_):
  //      self.feedList = []
  //      self.onFeedListUpdate?(0)
  //    }
  //  }
}
