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
  ],
  targets: [
    // --------------- Modules ---------------
    // Shared
    .target( name: "Shared", dependencies: [
    ]),
    
    // ---------------- Tests ----------------
    // SharedFeaturesTests
    .testTarget(name: "SharedFeaturesTests", dependencies: ["Shared"]),
  ]
)
