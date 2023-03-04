// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


// Sources copied from HomeKitADK
// SHA fb201f98f5fdc7fef6a455054f08b59cca5d1ec8
// https://github.com/apple/HomeKitADK

import PackageDescription

let macOSLinkFlags: CSetting = .unsafeFlags([
    "-L", "/opt/homebrew/Cellar/openssl@3/3.0.8/lib", "-l", "crypto"
], .when(platforms: [.macOS]))

let macOSIncludeFlags: CSetting = .unsafeFlags([
    "-I", "/opt/homebrew/Cellar/openssl@3/3.0.8/include"
], .when(platforms: [.macOS]))

var package = Package(
    name: "swift-homekit-adk",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "HomeKitADK",
            targets: ["HomeKitADK"]
        ),
        .executable(
            name: "AccessorySetupGenerator",
            targets: ["AccessorySetupGenerator"]
        ),
        .executable(
            name: "homekit-adk-lightbulb",
            targets: ["HomeKitADKLightbulb"]
        ),
        .executable(
            name: "homekit-adk-lock",
            targets: ["HomeKitADKLock"]
        )
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
                "COpenSSL",
                "Cdns_sd",
                "Bluetooth"
            ]
        ),
        .target(
            name: "CHomeKitADK",
            cSettings: [
                .define("SWIFTHOMEKIT"),
                .define("HAP_LOG_LEVEL", to: "3", .when(configuration: .debug)),
                macOSIncludeFlags
            ]
        ),
        .systemLibrary(
            name: "COpenSSL",
            pkgConfig: "openssl",
            providers: [
                .brew(["openssl"]),
                .apt(["openssl libssl-dev"])
            ]
        ),
        .executableTarget(
            name: "HomeKitADKLightbulb",
            dependencies: [
                "HomeKitADK",
                "COpenSSL",
            ],
            cSettings: [
                .define("IP"),
                macOSLinkFlags,
                macOSIncludeFlags
            ]
        ),
        .executableTarget(
            name: "HomeKitADKLock",
            dependencies: [
                "HomeKitADK",
                "COpenSSL",
            ],
            cSettings: [
                .define("BLE"),
                macOSLinkFlags,
                macOSIncludeFlags
            ]
        ),
        .executableTarget(
            name: "AccessorySetupGenerator",
            dependencies: [
                "HomeKitADK",
                "COpenSSL",
            ],
            cSettings: [
                macOSLinkFlags
            ]
        ),
        .testTarget(
            name: "HomeKitADKTests",
            dependencies: ["HomeKitADK"]
        ),
    ]
)

#if !os(Linux)
    package.targets.append(
        .systemLibrary(name: "Cdns_sd"))
#else
    package.targets.append(
        .systemLibrary(name: "Cdns_sd",
                       pkgConfig: "avahi-compat-libdns_sd",
                       providers: [
                           .apt(["libavahi-compat-libdnssd-dev"])
                       ]))
#endif
