// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "SwiftTools",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "SwiftTools", targets: ["SwiftTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.1"),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration", from: "2.8.1"),
        .package(url: "https://github.com/raptorxcz/xcbeautify", revision: "f2204485ba19bb36c4e62f4245a7b6f41d7d687a"),
    ],
    targets: [
        .target(name: "SwiftTools", dependencies: [
            "Swinject",
            "SwinjectAutoregistration",
            .product(name: "XcbeautifyLib", package: "xcbeautify"),
        ]),
        .testTarget(
            name: "SwiftToolsTests",
            dependencies: ["SwiftTools"]
        ),
    ]
)
