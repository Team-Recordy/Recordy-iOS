//
//  Project.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let moduleName = "Presentation"

let project = Project.makeModule(
  name: moduleName,
  destinations: [.iPhone],
  product: .staticFramework,
  bundleId: moduleName,
  dependencies: [
    .Project.Core,
    .Project.Common,
    .external(name: "SnapKit", condition: .none),
    .external(name: "Then", condition: .none),
    .external(name: "RxSwift", condition: .none),
    .external(name: "RxCocoa", condition: .none),
    .external(name: "Lottie", condition: .none),
    .external(name: "Kingfisher", condition: .none)
  ]
)
