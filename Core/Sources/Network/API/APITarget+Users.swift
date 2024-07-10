//
//  APITarget+Users.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  enum Users {
    case signIn
    case signUp
    case signOut
    case checkNickname
    case refreshToken
    case withdraw
    case getfollowList
    case getfollowerList
  }
}

extension APITarget.Users: TargetType {
  var baseURL: URL {
    return URL(string: "BASE_URL + /users")!
  }

  var path: String {
    switch self {
    case .signIn:
      "signIn"
    case .signUp:
      "signUp"
    case .signOut:
      "logout"
    case .checkNickname:
      "check-nickname"
    case .refreshToken:
      "token"
    case .withdraw:
      "delete"
    case .getfollowList:
      "follow"
    case .getfollowerList:
      "follower"
    }
  }

  var method: Moya.Method {
    switch self {
    case .signIn:
      return .post
    case .signUp:
      return .post
    case .signOut:
      return .delete
    case .checkNickname:
      return .get
    case .refreshToken:
      return .post
    case .withdraw:
      return .delete
    case .getfollowList:
      return .get
    case .getfollowerList:
      return .get
    }
  }

  var task: Moya.Task {
    return .requestPlain
  }

  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}