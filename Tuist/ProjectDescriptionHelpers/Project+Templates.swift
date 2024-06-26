//
//  Project+Templates.swift
//  Packages
//
//  Created by 한지석 on 6/25/24.
//

import ProjectDescription

extension Project {
  private static let organizationName = "com.recordy."
  private static let deploymentTarget = "16.0"

  public static func makeModule(
    name: String,
    destinations: Destinations,
    product: Product,
    bundleId: String,
    infoPlist: InfoPlist = .default,
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = nil,
    entitlements: Entitlements? = nil,
    dependencies: [TargetDependency] = [],
    target: Target? = nil
  ) -> Project {

    let target = Target.target(
      name: name,
      destinations: destinations,
      product: product,
      bundleId: organizationName + bundleId,
      deploymentTargets: .iOS(deploymentTarget),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: [],
      dependencies: dependencies
    )

    return Project(
      name: name,
      organizationName: organizationName,
      targets: [target]
    )
  }
}
