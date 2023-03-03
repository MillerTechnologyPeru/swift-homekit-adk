// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


// Sources copied from HomeKitADK
// SHA fb201f98f5fdc7fef6a455054f08b59cca5d1ec8
// https://github.com/apple/HomeKitADK

import PackageDescription

let package = Package(
    name: "swift-homekit-adk",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "HomeKitADK",
            targets: ["HomeKitADK"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/PureSwift/Bluetooth.git",
            .upToNextMajor(from: "6.0.0")
        ),
        
    ],
    targets: [
        .target(
            name: "HomeKitADK",
            dependencies: [
                "CHomeKitADK",
                "COpenSSL"
            ]
        ),
        .target(
            name: "CHomeKitADK",
            cSettings: [
                .define("SWIFTHOMEKIT"),
                .unsafeFlags([
                    "-I", "/opt/homebrew/Cellar/openssl@3/3.0.8/include",
                    //"-I", "/usr/local/opt/openssl/include",
                ], .when(platforms: [.macOS])),
            ],
            cxxSettings: [
                .define("SWIFTHOMEKIT"),
                .unsafeFlags([
                    "-I", "/opt/homebrew/Cellar/openssl@3/3.0.8/include",
                    //"-I", "/usr/local/opt/openssl/include",
                ], .when(platforms: [.macOS])),
            ]
        ),
        .systemLibrary(
            name: "COpenSSL",
            pkgConfig: "openssl",
            providers: [
                .brew(["openssl"]),
                .apt(["openssl libssl-dev"]),
            ]
        ),
        .testTarget(
            name: "HomeKitADKTests",
            dependencies: ["HomeKitADK"]
        )
    ]
)
