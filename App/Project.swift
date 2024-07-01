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
  ]
]

private let moduleName = "App"

let project = Project.makeModule(
  name: moduleName,
  destinations: [.iPhone],
  product: .app,
  bundleId: "app.recordy",
  infoPlist: .extendingDefault(with: infoPlist),
  resources: ["Resources/**"],
  dependencies: [
    .Project.Common,
    .Project.Core,
    .Project.Data,
    .Project.Presentation
  ]
)
