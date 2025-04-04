// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HogEnvironment",
  platforms: [.iOS(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HogEnvironment",
      targets: ["HogEnvironment"]
    )
  ],
  dependencies: [
    .package(name: "HogData", path: "../HogData"),
    .package(name: "HogAnalytics", path: "../HogAnalytics"),
    .package(name: "HogRouter", path: "../HogRouter"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "HogEnvironment",
      dependencies: ["HogRouter", "HogData", "HogAnalytics"]
    ),
    .testTarget(
      name: "HogEnvironmentTests",
      dependencies: ["HogEnvironment"]
    ),
  ]
)
