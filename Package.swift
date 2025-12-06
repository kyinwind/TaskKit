// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
// swift-tools-version: 5.9

let package = Package(
    name: "TaskKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "TaskKit", targets: ["TaskKit"])
    ],
    targets: [
        .target(
            name: "TaskKit",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("SwiftData")
            ]
        )
    ]
)
