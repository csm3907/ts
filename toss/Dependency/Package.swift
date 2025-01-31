// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dependency",
    platforms:  [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Dependency",
            targets: ["Dependency"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineCocoa", .upToNextMajor(from: "0.0.0")),
        .package(url: "https://github.com/CombineCommunity/CombineExt", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ashleymills/Reachability.swift", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "Dependency",
            dependencies: [
                "CombineCocoa",
                "CombineExt",
                .product(name: "Reachability", package: "Reachability.swift"),
                "SnapKit",
                "Then",
            ]
        ),
    ]
)
