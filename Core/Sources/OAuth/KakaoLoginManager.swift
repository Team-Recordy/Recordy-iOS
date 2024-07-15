//
//  KakaoLoginManager.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

public final class KakaoLoginManager {

  public init() { }
  
  public func login(completion: @escaping (Result<String, Error>) -> Void) {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        guard let authToken = oauthToken else { return }
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(authToken.accessToken))
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        guard let authToken = oauthToken else { return }
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(authToken.accessToken))
        }
      }
    }
  }
}
