//
//  AppleLoginManager.swift
//  Core
//
//  Created by 한지석 on 7/1/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import AuthenticationServices

public final class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate {
  public lazy var authorizationController: ASAuthorizationController = {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    return authorizationController
  }()

  public func loginWithApple() {
    self.authorizationController.performRequests()
  }

  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
      let email = appleIDCredential.email

      if let authorizationCode = appleIDCredential.authorizationCode,
         let identityToken = appleIDCredential.identityToken,
         let authCodeString = String(
          data: authorizationCode,
          encoding: .utf8
         ),
         let identifyTokenString = String(
          data: identityToken,
          encoding: .utf8
         ) {
        print("authorizationCode: \(authorizationCode)")
        print("identityToken: \(identityToken)")
        print("authCodeString: \(authCodeString)")
        print("identifyTokenString: \(identifyTokenString)")
      }
      print("useridentifier: \(userIdentifier)")

    case let passwordCredential as ASPasswordCredential:
      let username = passwordCredential.user
      let password = passwordCredential.password

      print("username: \(username)")
      print("password: \(password)")

    default:
      break
    }
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    print(#function)
  }
}
