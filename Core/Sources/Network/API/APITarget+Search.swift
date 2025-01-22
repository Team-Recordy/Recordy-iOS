//
//  APITarget+Search.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Search {
    case getSearch(DTO.GetSearchRequest)
  }
}

extension APITarget.Search: TargetType {

  public var validationType: ValidationType {
    .successCodes
  }
  
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/search")!
  }
  
  public var path: String {
    return ""
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Moya.Task {
    switch self {
    case .getSearch(let getSearchRequest):
      return .requestParameters(
        parameters: [
          "query": getSearchRequest.query
        ],
        encoding: URLEncoding.queryString
      )
    }
  }
  
  public var headers: [String : String]? {
    return .none
  }
}
