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
    case refreshToken(DTO.RefreshTokenRequest)
    case signUp(DTO.SignUpRequest)
    case signIn(DTO.SignInRequest)
    case checkNickname(DTO.CheckNicknameRequest)
    case signOut
    case withdraw
    case follow(DTO.FollowRequest)
    case editProfile(DTO.EditUserInfoRequest)
    case getProfile(DTO.GetProfileRequest)
    case getProfileImage(DTO.GetPresignedUrlResponse)
    case getFollowingList(DTO.GetFollowingListRequest)
    case getFollowerList(DTO.GetFollowerListRequest)
    case getPresignedUrl(DTO.GetPresignedImageUrlRequest)
  }
}

extension APITarget.Users: TargetType {
  
  public var validationType: ValidationType {
    .successCodes
  }
  
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/users")!
  }
  
  public var path: String {
    switch self {
    case .refreshToken:
      "token"
    case .signUp:
      "signUp"
    case .signIn:
      "signIn"
    case .checkNickname:
      "check-nickname"
    case .signOut:
      "logout"
    case .withdraw:
      "delete"
    case .follow(let followRequest):
      "follow/\(followRequest.followingId)"
    case .editProfile:
      "users"
    case .getProfile(let getProfileRequest):
      "profile/\(getProfileRequest.otherUserId)"
    case .getProfileImage:
      "presigned-url"
    case .getFollowingList:
      "following"
    case .getFollowerList:
      "follower"
    case .getPresignedUrl(_):
      "presigned-url"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .refreshToken:
      return .post
    case .signUp:
      return .post
    case .signIn:
      return .post
    case .checkNickname:
      return .get
    case .signOut:
      return .delete
    case .withdraw:
      return .delete
    case .follow:
      return .post
    case .editProfile:
      return .post
    case .getProfile:
      return .get
    case .getProfileImage:
      return .get
    case .getFollowingList:
      return .get
    case .getFollowerList:
      return .get
    case .getPresignedUrl(_):
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp(let signUpRequest):
      return .requestJSONEncodable(signUpRequest)
    case .signIn(let signInRequest):
      return .requestParameters(
        parameters: ["platformType": signInRequest.platformType.rawValue],
        encoding: JSONEncoding.default
      )
    case .checkNickname(let checkNicknameRequest):
      return .requestParameters(
        parameters: ["nickname": checkNicknameRequest.nickname],
        encoding: URLEncoding.queryString
      )
    case .editProfile(let editProfileRequest):
      return .requestParameters(
        parameters: [
          "nickname" : editProfileRequest.nickname,
          "profileImageUrl" : editProfileRequest.profileImageUrl
        ],
        encoding: JSONEncoding.default
      )
    case .getFollowingList(let getFollowingListRequest):
      var parameters: [String: Any] = ["size": getFollowingListRequest.size]
      if let cursorId = getFollowingListRequest.cursorId {
        parameters["cursorId"] = cursorId
      }
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.queryString
      )
    case .getFollowerList(let getFollowerListRequest):
      var parameters: [String: Any] = ["size": getFollowerListRequest.size]
      if let cursorId = getFollowerListRequest.cursorId {
        parameters["cursorId"] = cursorId
      }
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.queryString
      )
    case .getPresignedUrl(let request):
      return .requestJSONEncodable(request)
    default:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    switch self {
    case .signIn(let signInRequest):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(signInRequest.authorization)"
      ]
    case .getPresignedUrl:
      return ["Content-Type": "application/json"]
    default: return .none
    }
  }
}
