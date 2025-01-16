//
//  APITarget+Platform.swift
//  Core
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Platform {
    case getPlaces(DTO.GetPlatformPlaceRequest)
  }
}

extension APITarget.Platform: TargetType {
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/places/platform/search")!
  }

  public var path: String {
    return ""
  }

  public var method: Moya.Method {
    return .get
  }

  public var task: Moya.Task {
    switch self {
    case .getPlaces(let request):
      return .requestParameters(
        parameters: ["query": request.query],
        encoding: URLEncoding.queryString
      )
    }
  }

  public var headers: [String : String]? {
    return .none
  }
}
