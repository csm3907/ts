// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms:  [.iOS(.v15)],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(path: "../Dependency"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [.product(name: "Dependency", package: "Dependency")]
        )
    ]
)
