//
//  Project.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let moduleName = "App"

let project = Project.makeModule(
  name: moduleName,
  destinations: [.iPhone],
  product: .app,
  bundleId: "app.recordy",
  infoPlist: .default,
  resources: ["Resources/**"],
  dependencies: []
)
