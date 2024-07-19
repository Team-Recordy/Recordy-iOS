//
//  Project.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: Plist.Value] = [
  "CFBundleShortVersionString": "1.0.0",
  "CFBundleVersion": "1",
  "CFBundleDisplayName": "Recordy",
  "CFBundleURLTypes": [
    [
      "CFBundleTypeRole": "Editor",
      "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
    ],
  ],
  "UIMainStoryboardFile": "",
  "UILaunchStoryboardName": "LaunchScreen.storyboard",
  "UIApplicationSceneManifest": [
    "UIApplicationSupportsMultipleScenes": false,
    "UISceneConfigurations": [
      "UIWindowSceneSessionRoleApplication": [
        [
          "UISceneConfigurationName": "Default Configuration",
          "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
        ],
      ]
    ]
  ],
  "LSApplicationQueriesSchemes": [
    "kakaokompassauth",
    "kakaolink",
    "kakao$(KAKAO_NATIVE_APP_KEY)"
  ],
  "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
  "BASE_URL": "$(BASE_URL)",
  "NSPhotoLibraryUsageDescription": "앱에서 사진 라이브러리에 접근하려면 권한이 필요합니다.",
  "NSAppTransportSecurity": [
    "NSAllowsArbitraryLoads": true
  ]
]

private let settings = Settings.settings(configurations: [
  .debug(name: "Debug", xcconfig:
      .relativeToRoot("App/Config/Secrets.xcconfig")),
  .release(name: "Release", xcconfig: .relativeToRoot("App/Config/Secrets.xcconfig")),
])

private let moduleName = "App"

let project = Project.makeModule(
  name: moduleName,
  destinations: [.iPhone],
  product: .app,
  bundleId: "app.recordy",
  infoPlist: .extendingDefault(with: infoPlist),
  resources: ["Resources/**"],
  entitlements: .file(path: "App.entitlements"),
  dependencies: [
    .Project.Core,
    .Project.Presentation,
    .external(name: "KakaoSDKAuth", condition: .none),
    .external(name: "KakaoSDKCommon", condition: .none),
    .external(name: "KakaoSDKUser", condition: .none)
  ],
  settings: settings
)
