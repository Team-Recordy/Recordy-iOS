//
//  RegisterPlaceSearchViewModel.swift
//  Presentation
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation
import Combine

import Core

//"platformPlaceId": "aldkjf3jbf",
//"address": "서울시 마포구 독막로 209",
//"longitude": 100.435,
//"latitude": 34.55,
//"name": "초록불꽃소년단의 복귀 공연"

final class RegisterPlaceSearchViewModel {

  struct Place {
    let id: String
    let address: String
    let name: String
    let position: (latitude: Double, longitude: Double)
  }

  private let apiProvider = APIProvider<APITarget.Platform>()
  @Published var searchText: String = ""
  @Published var searchedPlace: [Place] = []
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
    let request = DTO.GetPlatformPlaceRequest(query: searchText)
    apiProvider.requestResponsable(
      .getPlaces(request),
      [DTO.GetPlatformPlaceResponse].self
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let response):
        let responseData = response.map {
          Place(
            id: $0.platformPlaceId,
            address: $0.address,
            name: $0.name,
            position: ($0.latitude, $0.longitude)
          )
        }
        self.searchedPlace = responseData
      case .failure(let failure):
        self.searchedPlace = []
      }
    }
  }
}

