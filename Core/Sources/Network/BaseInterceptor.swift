//
//  BaseInterceptor.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Alamofire

final class BaseInterceptor: RequestInterceptor {
  
  let keychainManager = KeychainManager.shared
  
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    print("HI")
    var request = urlRequest
    guard !(request.url?.absoluteString.contains("signIn"))! else { 
      return completion(.success(request))
    }
    request.headers.add(.contentType("application/json"))
    if request.url?.absoluteString.contains("/refresh") == false {
      if let accessToken = keychainManager.read(token: .AccessToken) {
        request.headers.add(.authorization(bearerToken: accessToken))
      }
    } else {
      if let refreshToken = keychainManager.read(token: .RefreshToken) {
        request.headers.add(.authorization(bearerToken: refreshToken))
      }
    }
    completion(.success(request))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let refreshToken = keychainManager.read(token: .RefreshToken),
          request.response?.statusCode == 401,
          let urlString = request.response?.url?.absoluteString,
          !urlString.contains("refresh") else {
      completion(.doNotRetryWithError(error))
      return
    }
    let apiProvider = APIProvider<APITarget.Users>()
    let request = DTO.RefreshTokenRequest(authorization: refreshToken)
    apiProvider.requestResponsable(.refreshToken(request), DTO.RefreshTokenResponse.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.keychainManager.create(
          token: .AccessToken,
          value: response.accessToken
        )
        completion(.retry)
      case .failure(let error):
        completion(.doNotRetryWithError(error))
      }
    }
  }
}


