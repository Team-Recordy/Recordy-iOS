//
//  AppDelegate.swift
//  App
//
//  Created by 한지석 on 6/26/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    KakaoSDK.initSDK(appKey: nativeAppKey as! String)
    return true
  }
}
