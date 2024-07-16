//
//  AppleLoginManager.swift
//  Core
//
//  Created by 한지석 on 7/1/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

//import Foundation
//import AuthenticationServices
//
//public final class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//
//  private var window: UIWindow?
//
//  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//    return self.window!
//  }
//
//  public lazy var authorizationController: ASAuthorizationController = {
//    let appleIDProvider = ASAuthorizationAppleIDProvider()
//    let request = appleIDProvider.createRequest()
//    request.requestedScopes = [.email, .fullName]
//    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//    authorizationController.delegate = self
//    authorizationController.presentationContextProvider = self
//    return authorizationController
//  }()
//
//  public init(window: UIWindow?) {
//    self.window = window
//  }
//
//  public func loginWithApple() {
//    self.authorizationController.performRequests()
//  }
//
//  public func authorizationController(
//    controller: ASAuthorizationController,
//    didCompleteWithAuthorization authorization: ASAuthorization
//  ) {
//    switch authorization.credential {
//    case let appleIDCredential as ASAuthorizationAppleIDCredential:
//      let userIdentifier = appleIDCredential.user
//      let fullName = appleIDCredential.fullName
//      let email = appleIDCredential.email
//      if let authorizationCode = appleIDCredential.authorizationCode,
//         let identityToken = appleIDCredential.identityToken,
//         let authCodeString = String(
//          data: authorizationCode,
//          encoding: .utf8
//         ),
//         let identifyTokenString = String(
//          data: identityToken,
//          encoding: .utf8
//         ) {
//      }
//
//    case let passwordCredential as ASPasswordCredential:
//      let username = passwordCredential.user
//      let password = passwordCredential.password
//    default:
//      break
//    }
//  }
//
//  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//  }
//}
