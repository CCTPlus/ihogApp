// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Models",
  platforms: [.iOS(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Models",
      targets: ["Models"]
    ),
    .library(
      name: "DataManager",
      targets: ["DataManager"]
    ),
  ],
  dependencies: [.package(name: "Utilities", path: "../Utilities")],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Models"
    ),
    .target(
      name: "DataManager",
      dependencies: [
        .product(name: "Analytics", package: "Utilities"),
        .product(name: "Utilities", package: "Utilities"),
      ]
    ),
    .testTarget(
      name: "ModelsTests",
      dependencies: ["Models"]
    ),
  ]
)