// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms:  [.iOS(.v15)],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Design"),
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Feature",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "Design", package: "Design"),
            ]
        )
    ]
)
