// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SwiftTools",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "SwiftTools", targets: ["SwiftTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.1"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration", from: "2.8.1"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", exact: "6.0.3"),
        .package(url: "https://github.com/cpisciotta/xcbeautify", exact: "2.8.0"),
    ],
    targets: [
        .target(name: "SwiftTools", dependencies: [
            "Swinject",
            "SwinjectAutoregistration",
            "SwiftCLI",
            .product(name: "XcbeautifyLib", package: "xcbeautify"),
        ]),
        .testTarget(
            name: "SwiftToolsTests",
            dependencies: ["SwiftTools"]
        ),
    ]
)
