// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Utilities",
  platforms: [.iOS(.v16)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Utilities",
      targets: ["Utilities"]
    ),
    .library(name: "Analytics", targets: ["Analytics"]),
  ],
  dependencies: [
    .package(url: "https://github.com/TelemetryDeck/SwiftSDK", from: "2.5.1"),
    .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Analytics",
      dependencies: [
        .product(name: "TelemetryDeck", package: "SwiftSDK"),
        .product(name: "PostHog", package: "posthog-ios"),
        .byName(name: "Utilities"),
      ]
    ),
    .target(
      name: "Utilities"
    ),
    .testTarget(
      name: "UtilitiesTests",
      dependencies: ["Utilities"]
    ),
  ]
)
