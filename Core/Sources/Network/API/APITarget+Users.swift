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
    case signUp(DTO.SignUpRequest)
    case signOut // 로그아웃
    case checkNickname(DTO.CheckNicknameRequest)
    case refreshToken(DTO.RefreshTokenRequest)
    case withdraw // 회원 탈퇴
    case getfollowList(DTO.GetFollowListRequest)
    case getfollowerList(DTO.GetFollowerListRequest)
    case follow(DTO.FollowRequest)
    case getProfile
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
      "following"
    case .getfollowerList:
      "follower"
    case .follow:
      "follow"
    case .getProfile:
      "profile"
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
    case .follow:
      return .post
    case .getProfile:
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
    case .signUp(let signUpRequest):
      return .requestJSONEncodable(signUpRequest)
    case .checkNickname(let checkNicknameRequest):
      return .requestParameters(
        parameters: ["nickname": checkNicknameRequest.nickname],
        encoding: URLEncoding.queryString
      )
    case .getfollowList(let getFollowListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getFollowListRequest.cursorId,
          "size": getFollowListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .getfollowerList(let getFollowerListRequest):
      return .requestParameters(
        parameters: [
          "cursorId": getFollowerListRequest.cursorId,
          "size": getFollowerListRequest.size
        ],
        encoding: URLEncoding.queryString
      )
    case .follow(let followRequest):
      return .requestParameters(
        parameters: ["followingId": followRequest.followingId],
        encoding: URLEncoding.queryString
      )
    default:
      return .requestPlain
    }
  }

  public var headers: [String : String]? {
    return .none
  }
}
