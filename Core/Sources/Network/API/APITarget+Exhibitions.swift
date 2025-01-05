//
//  APITarget+Exhibitions.swift
//  Core
//
//  Created by Chandrala on 12/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Exhibitions {
    case getExhibitionList(DTO.GetExhibitionListRequest)
    case createExhibition(DTO.CreateExhibitionRequest)
    case editExhibition(DTO.EditExhibitionRequest)
    case getFreeExhibitionList(DTO.GetFreeExhibitionListRequest)
    case getOngoingExhibitionList(DTO.GetOngoingExhibitionListRequest)
    case deleteExhibition(DTO.DeleteExhibitionRequest)
  }
}

extension APITarget.Exhibitions: TargetType {
  
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/exhibitions")!
  }
  
  public var path: String {
    switch self {
    case .getExhibitionList:
      return ""
    case .createExhibition:
      return ""
    case .editExhibition:
      return ""
    case .getFreeExhibitionList:
      return "free"
    case .getOngoingExhibitionList:
      return "closing"
    case .deleteExhibition(let deleteExhibitionRequest):
      return "\(deleteExhibitionRequest.exhibitionId)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .getExhibitionList:
      return .get
    case .createExhibition:
      return .post
    case .editExhibition:
      return .post
    case .getFreeExhibitionList:
      return .get
    case .getOngoingExhibitionList:
      return .get
    case .deleteExhibition:
      return .delete
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .getExhibitionList(let getExhibitionListRequest):
      return .requestParameters(
        parameters: [
          "placeId": getExhibitionListRequest.placeId,
        ],
        encoding: URLEncoding.queryString
      )
    case .createExhibition(let createExhibition):
      return .requestJSONEncodable(createExhibition)
    case .editExhibition(let editExhibition):
      return .requestJSONEncodable(editExhibition)
    case .getFreeExhibitionList(let getFreeExhibitionListRequest):
      return .requestParameters(
        parameters: [
          "placeId": getFreeExhibitionListRequest.placeId
        ],
        encoding: URLEncoding.queryString
      )
    case .getOngoingExhibitionList(let getOngoingExhibitionListRequest):
      return .requestParameters(
        parameters: [
          "placeId": getOngoingExhibitionListRequest.placeId
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
