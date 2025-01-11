// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Whisp",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "WhispAgent",
            targets: ["WhispAgent"]
        ),
        .library(
            name: "Whisp",
            targets: ["Whisp"]
        ),
        .executable(
            name: "WhispDemo",
            targets: ["WhispDemo"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/daltoniam/Starscream.git",
            from: "4.0.8"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.17.1"
        )
    ],
    targets: [
        .target(
            name: "WhispAgent",
            dependencies: [
                .product(name: "Starscream", package: "Starscream")
            ]
        ),
        .target(
            name: "Whisp",
            dependencies: [
                "WhispAgent",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),
        .executableTarget(
            name: "WhispDemo",
            dependencies: ["WhispAgent"]
        )
    ]
)
