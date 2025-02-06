//
//  SceneDelegate.swift
//  App
//
//  Created by 한지석 on 6/26/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Core
import Presentation

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

    let loginVC = LoginViewController()
    let navigationController = UINavigationController(rootViewController: loginVC)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    checkInitialToken()
  }

  private func checkInitialToken() {
    if KeychainManager.shared.read(token: .AccessToken) != nil {
      if !KeychainManager.shared.isRefreshTokenValid() {
        KeychainManager.shared.delete(token: .AccessToken)
        KeychainManager.shared.delete(token: .RefreshToken)
        navigateToLogin()
        return
      }
      let mainVC = RecordyTabBarController()
      window?.rootViewController = mainVC
    } else {
      navigateToLogin()
    }
    window?.makeKeyAndVisible()
  }

  private func navigateToLogin() {
    let loginVC = LoginViewController()
    let navigationController = UINavigationController(rootViewController: loginVC)
    navigationController.modalPresentationStyle = .fullScreen

    UIView.transition(with: window!,
                      duration: 0.3,
                      options: .transitionCrossDissolve,
                      animations: {
      self.window?.rootViewController = navigationController
    })
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
