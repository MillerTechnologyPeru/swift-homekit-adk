// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-homekit-adk",
    products: [
        .library(
            name: "HomeKitADK",
            targets: ["HomeKitADK"]
        ),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "HomeKitADK",
            dependencies: []
        ),
        .testTarget(
            name: "HomeKitADKTests",
            dependencies: ["HomeKitADK"]
        )
    ]
)
