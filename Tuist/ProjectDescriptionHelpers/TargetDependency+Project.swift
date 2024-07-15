//
//  TargetDependency+Project.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription

public extension TargetDependency {
  enum Project {}
}

public extension TargetDependency.Project {
  static let Common = TargetDependency.project(
    target: "Common",
    path: .relativeToRoot(
      "Common"
    )
  )
  static let Core = TargetDependency.project(
    target: "Core",
    path: .relativeToRoot(
      "Core"
    )
  )
  static let Presentation = TargetDependency.project(
    target: "Presentation",
    path: .relativeToRoot(
      "Presentation"
    )
  )
}
