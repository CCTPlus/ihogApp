// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iHogKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "AppInfoCore", targets: ["AppInfoCore"]),
        .library(name: "AppInfoView", targets: ["AppInfoView"]),
        .library(name: "AppView", targets: ["AppView"]),
        .library(
            name: "iHogKit",
            targets: ["iHogKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            exact: "1.5.6"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppView",
            dependencies: ["AppCore", "AppInfoView"]
        ),
        .target(
            name: "AppCore",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(
            name: "AppInfoCore",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(name: "AppInfoView", dependencies: ["AppInfoCore"]),
        .target(
            name: "iHogKit"
        ),
        .testTarget(
            name: "iHogKitTests",
            dependencies: ["iHogKit"]
        ),
    ]
)
