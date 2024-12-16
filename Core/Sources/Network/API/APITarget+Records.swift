//
//  APITarget+Records.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Records {
    case createRecord(DTO.CreateRecordRequest)
    case getUserRecordList(DTO.GetUserRecordListRequest)
    case getRandomRecordList(DTO.GetRandomRecordListRequest)
    case getPresignedUrl
    case getPlaceRecordList(DTO.GetPlaceRecordListRequest)
    case getFollowingRecordList(DTO.GetFollowingRecordListRequest)
    case getBookmarkedRecordList(DTO.GetBookmarkedListRequest)
    case deleteRecord(DTO.DeleteRecordRequest)
  }
}


extension APITarget.Records: TargetType {
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/records")!
  }

  public var path: String {
    switch self {
    case .createRecord:
      return ""
    case .getUserRecordList(let getUserRecordListRequest):
      return "user/\(getUserRecordListRequest.otherUserId)"
    case .getRandomRecordList(let getRandomRecordListRequest):
      return "random"
    case .getPresignedUrl:
      return "presigned-url"
    case .getPlaceRecordList:
      return "place"
    case .getFollowingRecordList:
      return "follow"
    case .getBookmarkedRecordList:
      return "bookmarks"
    case .deleteRecord(let deleteRecordRequest):
      return "\(deleteRecordRequest.record_id)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .createRecord:
      return .post
    case .getUserRecordList:
      return .get
    case .getRandomRecordList:
      return .get
    case .getPresignedUrl:
      return .get
    case .getPlaceRecordList:
      return .get
    case .getFollowingRecordList:
      return .get
    case .getBookmarkedRecordList:
      return .get
    case .deleteRecord:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .createRecord(let createRecordRequest):
      return .requestJSONEncodable(createRecordRequest)
    case .getUserRecordList(let getUserRecordListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getUserRecordListRequest.cursorId,
          "size": getUserRecordListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .getRandomRecordList(let getRandomRecordListRequest):
      return .requestParameters(
        parameters: [
          "size": getRandomRecordListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .deleteRecord:
      return .requestPlain
    case .getPlaceRecordList(let getPlaceRecordListRequest):
      return .requestParameters(
        parameters: [
          "placeId": getPlaceRecordListRequest.placeId,
          "cursorId": getPlaceRecordListRequest.cursorId,
          "size": getPlaceRecordListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .getFollowingRecordList(let getFollowingRecordListRequest):
      return .requestParameters(
        parameters: ["size": getFollowingRecordListRequest.size],
        encoding: URLEncoding.queryString
      )
    case .getBookmarkedRecordList(let getBookmarkedRecordListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getBookmarkedRecordListRequest.cursorId,
          "size": getBookmarkedRecordListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    default: return .requestPlain
      
//    case .getRecentRecordList(let getRecentRecordListRequest):
//      var parameters: [String: Any]
//      if getRecentRecordListRequest.keywords == nil {
//        parameters = [
//          "cursorId": getRecentRecordListRequest.cursorId,
//          "size": getRecentRecordListRequest.size
//        ]
//      } else {
//        parameters = [
//          "keywords": getRecentRecordListRequest.keywords!,
//          "cursorId": getRecentRecordListRequest.cursorId,
//          "size": getRecentRecordListRequest.size
//        ]
//      }
//      return .requestParameters(
//        parameters: parameters,
//        encoding: URLEncoding.queryString
//      )
      
//    case .getFamousRecordList(let getFamousRecordListRequest):
//      var parameters: [String: Any]
//      if getFamousRecordListRequest.keywords == nil {
//        parameters = [
//          "pageNumber": getFamousRecordListRequest.pageNumber,
//          "pageSize": getFamousRecordListRequest.pageSize
//        ]
//      } else {
//        parameters = [
//          "keywords": getFamousRecordListRequest.keywords!,
//          "pageNumber": getFamousRecordListRequest.pageNumber,
//          "pageSize": getFamousRecordListRequest.pageSize
//        ]
//      }
//      return .requestParameters(
//        parameters: parameters,
//        encoding: URLEncoding.queryString
//      )
    }
  }

  public var headers: [String : String]? {
    return .none
  }
}
