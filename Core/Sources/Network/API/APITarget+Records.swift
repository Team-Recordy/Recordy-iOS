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

//extension APITarget.Records {
//  static func 
//}

extension APITarget.Records: TargetType {
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/records")!
  }

  public var path: String {
    switch self {
    case .getPresignedUrl:
      return "presigned-url"
    case .createRecord(let createRecordRequest):
      return ""
    case .deleteRecord(let deleteRecordRequest):
      return "\(deleteRecordRequest.record_id)"
    case .isRecordWatched(let isRecordWatchedRequest):
      return "\(isRecordWatchedRequest.recordId)"
    case .getRecordList:
      return ""
    case .getUserRecordList(let getUserRecordListRequest):
      return "user/\(getUserRecordListRequest.otherUserId)"
    case .getRecentRecordList(let getRecentRecordListRequest):
      return "recent"
    case .getFamousRecordList(let getFamousRecordListRequest):
      return "famous"
    case .getFollowingRecordList(let getFollowingRecordListRequest):
      return "following"
    case .getBookmarkedRecordList(let getBookmarkedListRequest):
      return "bookmark"
    }

  }

  /// 다 붙이고 수정하기
  public var method: Moya.Method {
    switch self {
    case .getPresignedUrl:
      return .get
    case .createRecord(let createRecordRequest):
      return .post
    case .deleteRecord(let deleteRecordRequest):
      return .delete
    case .isRecordWatched(let isRecordWatchedRequest):
      return .post
    case .getRecordList(let getRecordListRequest):
      return .get
    case .getUserRecordList(let getUserRecordListRequest):
      return .get
    case .getRecentRecordList(let getRecentRecordListRequest):
      return .get
    case .getFamousRecordList(let getFamousRecordListRequest):
      return .get
    case .getFollowingRecordList(let getFollowingRecordListRequest):
      return .get
    case .getBookmarkedRecordList(let getBookmarkedListRequest):
      return .get
    }
  }

  public var task: Moya.Task {
    switch self {
    case .createRecord(let createRecordRequest):
      return .requestJSONEncodable(createRecordRequest)
    case .deleteRecord(let deleteRecordRequest):
      return .requestPlain
    case .isRecordWatched(let isWatchRecordRequest):
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
      return .requestParameters(
        parameters: [
          "keywords": getRecentRecordListRequest.keywords,
          "pageNumber": getRecentRecordListRequest.pageNumber,
          "pageSize":
            getRecentRecordListRequest.pageSize
        ],
        encoding: URLEncoding.queryString
      )
    case .getFamousRecordList(let getFamousRecordListRequest):
      return .requestParameters(
        parameters: [
          "keywords": getFamousRecordListRequest.keywords,
          "pageNumber": getFamousRecordListRequest.pageNumber,
          "pageSize":
            getFamousRecordListRequest.pageSize
        ],
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
