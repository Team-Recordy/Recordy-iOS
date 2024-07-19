//
//  SceneDelegate.swift
//  App
//
//  Created by 한지석 on 6/26/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Presentation
import Core

import KakaoSDKAuth

@available(iOS 16.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    if let url = URLContexts.first?.url {
      if (AuthApi.isKakaoTalkLoginUrl(url)) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (
      scene as? UIWindowScene
    ) else {
      return
    }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
//    let rootViewController = SignupViewController()
//    self.window?.rootViewController = rootViewController
//    self.window?.makeKeyAndVisible()
//    KeychainManager.shared.delete(token: .AccessToken)
//    KeychainManager.shared.delete(token: .RefreshToken)
    APIProvider<APITarget.Users>.validateToken { login in
      DispatchQueue.main.async {
        var rootViewController: UIViewController
        if login {
          rootViewController = RecordyTabBarController()
        } else {
          rootViewController = UINavigationController(rootViewController: SplashScreenViewController())
        }
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
      }
    }
  }
}
