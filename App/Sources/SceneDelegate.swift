//
//  SceneDelegate.swift
//  App
//
//  Created by 한지석 on 6/26/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Presentation
import Common

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
    let rootViewController = RecordyTabBarController()
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
}
