// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Whisp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Whisp",
            type: .dynamic,
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
        )
    ],
    targets: [
        .target(
            name: "Whisp",
            dependencies: [
                .product(name: "Starscream", package: "Starscream")
            ]
        ),
        .executableTarget(
            name: "WhispDemo",
            dependencies: ["Whisp"]
        )
    ]
)
