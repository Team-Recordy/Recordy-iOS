// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "SnapKit": .framework,
    "Then": .framework
  ]
)
#endif

let package = Package(
  name: "Recordy-iOS",
  dependencies: [
    .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
    .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master")
  ]
)
