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
    case getPresignedUrl
    case createRecord(DTO.CreateRecordRequest)
    case deleteRecord(DTO.DeleteRecordRequest)
    case isRecordWatched(DTO.IsRecordWatchedRequest)
    case getRecordList(DTO.GetRecordListRequest)
    case getUserRecordList(DTO.GetUserRecordListRequest)
    case getRecentRecordList(DTO.GetRecentRecordListRequest)
    case getFamousRecordList(DTO.GetFamousRecordListRequest)
    case getFollowingRecordList(DTO.GetFollowingRecordListRequest)
    case getBookmarkedRecordList(DTO.GetBookmarkedListRequest)
  }
}


extension APITarget.Records: TargetType {
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/records")!
  }

  public var path: String {
    switch self {
    case .getPresignedUrl:
      return "presigned-url"
    case .createRecord:
      return ""
    case .deleteRecord(let deleteRecordRequest):
      return "\(deleteRecordRequest.record_id)"
    case .isRecordWatched(let isRecordWatchedRequest):
      return "\(isRecordWatchedRequest.recordId)"
    case .getRecordList:
      return ""
    case .getUserRecordList(let getUserRecordListRequest):
      return "user/\(getUserRecordListRequest.otherUserId)"
    case .getRecentRecordList:
      return "recent"
    case .getFamousRecordList:
      return "famous"
    case .getFollowingRecordList:
      return "follow"
    case .getBookmarkedRecordList:
      return "bookmarks"
    }
  }

  /// 다 붙이고 수정하기
  public var method: Moya.Method {
    switch self {
    case .getPresignedUrl:
      return .get
    case .createRecord:
      return .post
    case .deleteRecord:
      return .delete
    case .isRecordWatched:
      return .post
    case .getRecordList:
      return .get
    case .getUserRecordList:
      return .get
    case .getRecentRecordList:
      return .get
    case .getFamousRecordList:
      return .get
    case .getFollowingRecordList:
      return .get
    case .getBookmarkedRecordList:
      return .get
    }
  }

  public var task: Moya.Task {
    switch self {
    case .createRecord(let createRecordRequest):
      return .requestJSONEncodable(createRecordRequest)
    case .deleteRecord:
      return .requestPlain
    case .isRecordWatched:
      return .requestPlain
    case .getRecordList(let getRecordListRequest):
      return .requestParameters(
        parameters: ["size": getRecordListRequest.size],
        encoding: URLEncoding.queryString
      )
    case .getUserRecordList(let getUserRecordListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getUserRecordListRequest.cursorId,
          "size": getUserRecordListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .getRecentRecordList(let getRecentRecordListRequest):
      var parameters: [String: Any]
      if getRecentRecordListRequest.keywords == nil {
        parameters = [
          "cursorId": getRecentRecordListRequest.cursorId,
          "size": getRecentRecordListRequest.size
        ]
      } else {
        parameters = [
          "keywords": getRecentRecordListRequest.keywords!,
          "cursorId": getRecentRecordListRequest.cursorId,
          "size": getRecentRecordListRequest.size
        ]
      }
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.queryString
      )
    case .getFamousRecordList(let getFamousRecordListRequest):
      var parameters: [String: Any]
      if getFamousRecordListRequest.keywords == nil {
        parameters = [
          "pageNumber": getFamousRecordListRequest.pageNumber,
          "pageSize": getFamousRecordListRequest.pageSize
        ]
      } else {
        parameters = [
          "keywords": getFamousRecordListRequest.keywords!,
          "pageNumber": getFamousRecordListRequest.pageNumber,
          "pageSize": getFamousRecordListRequest.pageSize
        ]
      }
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.queryString
      )
    case .getFollowingRecordList(let getFollowingRecordListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getFollowingRecordListRequest.cursorId,
          "size": getFollowingRecordListRequest.size
        ],
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
    }
  }

  public var headers: [String : String]? {
    return .none
  }
}
