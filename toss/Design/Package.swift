// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Design",
    platforms:  [.iOS(.v15)],
    products: [
        .library(
            name: "Design",
            targets: ["Design"]),
    ],
    dependencies: [
        .package(path: "../Dependency"),
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "Design",
            dependencies: [
                .product(name: "Dependency", package: "Dependency"),
                .product(name: "Core", package: "Core"),
            ]
        )
    ]
)
