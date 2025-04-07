// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HogShow",
  platforms: [.iOS(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HogShow",
      targets: ["HogShow"]
    )
  ],
  dependencies: [
    .package(name: "HogUtilities", path: "../HogUtilities"),
    .package(name: "HogData", path: "../HogData"),
    .package(name: "HogAnalytics", path: "../HogAnalytics"),
    .package(name: "HogRouter", path: "../HogRouter"),
    .package(name: "HogEnvironment", path: "../HogEnvironment"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "HogShow",
      dependencies: [
        "HogUtilities", "HogRouter", "HogData", "HogAnalytics", "HogEnvironment",
      ]
    ),
    .testTarget(
      name: "HogShowTests",
      dependencies: ["HogShow"]
    ),
  ]
)
