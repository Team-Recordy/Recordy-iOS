//
//  Project.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let moduleName = "Core"

let project = Project.makeModule(
  name: moduleName,
  destinations: [.iPhone],
  product: .staticFramework,
  bundleId: moduleName,
  dependencies: [
    .external(name: "KakaoSDKAuth", condition: .none),
    .external(name: "KakaoSDKCommon", condition: .none),
    .external(name: "KakaoSDKUser", condition: .none),
    .external(name: "Moya", condition: .none),
    .external(name: "RxSwift", condition: .none),
    .external(name: "RxMoya", condition: .none),
    .external(name: "RxSwift", condition: .none),
    .external(name: "RxCocoa", condition: .none),
    .external(name: "AWSS3", condition: .none)
  ]
)
