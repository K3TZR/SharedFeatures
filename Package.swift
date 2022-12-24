// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SharedFeatures",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],

  products: [
    .library(name: "Shared", targets: ["Shared"]),
  ],

  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
  ],

  targets: [
    // --------------- Modules ---------------
    // Shared
    .target( name: "Shared", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ---------------- Tests ----------------
    // SharedFeaturesTests
    .testTarget(name: "SharedFeaturesTests", dependencies: [
      "Shared",
    ]),
  ]
)
