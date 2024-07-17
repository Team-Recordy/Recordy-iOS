//
//  APITarget+Bookmark.swift
//  Core
//
//  Created by 한지석 on 7/17/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Bookmark {
    case postBookmark(DTO.PostBookmarkRequest)
  }
}

extension APITarget.Bookmark: TargetType {
  
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/bookmarks")!
  }
  
  public var path: String {
    switch self {
    case .postBookmark(let postBookmarkRequest):
      return "\(postBookmarkRequest.recordId)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .postBookmark:
      return .post
    }
  }
  
  public var task: Moya.Task {
    return .requestPlain
  }
  
  public var headers: [String : String]? {
    return .none
  }
}
