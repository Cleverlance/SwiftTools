// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "SwiftTools", targets: ["SwiftTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .exact("2.7.1")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration", .exact("2.7.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .exact("0.49.4")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .exact("6.0.3")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .exact("2.25.0")),
        .package(name: "XcodeProj", url: "https://github.com/tuist/xcodeproj.git", .exact("8.3.1")),
    ],
    targets: [
        .target(name: "SwiftTools", dependencies: [
            "Swinject",
            "SwinjectAutoregistration",
            "SwiftFormat",
            "SwiftCLI",
            .product(name: "XcodeGenKit", package: "XcodeGen"),
            "XcodeProj",
        ]),
    ]
)
