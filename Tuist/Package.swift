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
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
    .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.0")
  ]
)
