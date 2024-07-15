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
  public enum Users {
    case signIn(DTO.SignInRequest)
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
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/users")!
  }

  public var path: String {
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

  public var method: Moya.Method {
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

  public var task: Moya.Task {
    switch self {
    case .signIn(let signInRequest):
      return .requestParameters(
        parameters: ["platformType": signInRequest.platformType.rawValue],
        encoding: JSONEncoding.default
      )
    default:
      return .requestPlain
    }
  }

  public var headers: [String : String]? {
    switch self {
    case .signIn(let signInRequest):
      return [
        "Content-Type": "application/json",
        "Authorization": signInRequest.authorization
      ]
    default:
      return ["Content-Type": "application/json"]
    }

  }
}
