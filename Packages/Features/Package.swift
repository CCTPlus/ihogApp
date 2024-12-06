// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Features",
      targets: ["Features"]
    ),
    .library(name: "DesignSystem", targets: ["DesignSystem"]),
    .library(name: "Router", targets: ["Router"]),
    .library(name: "AppEntry", targets: ["AppEntry"]),
  ],
  dependencies: [
    .package(path: "../Utilities"),
    .package(path: "../Models"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "DesignSystem",
      dependencies: [
        "Router",
        .product(name: "DataManager", package: "Models"),
        .product(name: "Analytics", package: "Utilities"),
      ]
    ),
    .target(
      name: "Router"
    ),
    .target(
      name: "AppEntry",
      dependencies: [
        "DesignSystem",
        "Router",
        "Settings",
        .product(name: "DataManager", package: "Models"),
      ]
    ),
    .target(
      name: "Settings"
    ),
    .target(
      name: "Features"
    ),
    .testTarget(
      name: "FeaturesTests",
      dependencies: ["Features"]
    ),
  ]
)
