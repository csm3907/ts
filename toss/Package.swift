// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
        // dependencies...
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [],
            resources: [
                .copy("Resources/cached.json")  // .process 대신 .copy 사용
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("StrictConcurrency"),
                .define("ENABLE_BUNDLE_MODULE") // Bundle.module 활성화
            ]
        )
    ]
) 