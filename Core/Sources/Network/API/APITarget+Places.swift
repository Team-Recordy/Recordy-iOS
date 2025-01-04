//
//  APITarget+Places.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Places {
    case createPlace(DTO.CreatePlaceRequest)
    case getPlaceList(id: Int)
    case getNearPlaceList(DTO.GetNearPlaceListRequest)
    case getOngoingExhibitionPlaceList(DTO.GetOngoingExhibitionPlaceListRequest)
  }
}

extension APITarget.Places: TargetType {
  
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/places")!
  }
  
  public var path: String {
    switch self {
    case .createPlace:
      return ""
    case .getPlaceList(let id):
      return "\(id)"
    case .getNearPlaceList:
      return "exhibitions/geography"
    case.getOngoingExhibitionPlaceList:
      return "exhibitions/date"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .createPlace:
      return .post
    case .getPlaceList:
      return .get
    case .getNearPlaceList:
      return .get
    case .getOngoingExhibitionPlaceList:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .createPlace(let createPlaceRequest):
      return .requestJSONEncodable(createPlaceRequest)
    case .getNearPlaceList(let getNearPlaceListRequest):
      return .requestParameters(
        parameters: [
          "number": getNearPlaceListRequest.number,
          "size": getNearPlaceListRequest.size,
          "latitude": getNearPlaceListRequest.latitude,
          "longitude": getNearPlaceListRequest.longitude,
          "distance": getNearPlaceListRequest.distance
        ],
        encoding: URLEncoding.queryString
      )
    case .getOngoingExhibitionPlaceList(let getOngoingExhibitionPlaceListRequest):
      return .requestParameters(
        parameters: [
          "number": getOngoingExhibitionPlaceListRequest.number,
          "size": getOngoingExhibitionPlaceListRequest.size,
        ],
        encoding: URLEncoding.queryString
      )
    default: return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return .none
  }
}
