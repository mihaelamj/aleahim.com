// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "aleahim-cv",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/mihaelamj/cvbuilder.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "GenerateCV",
            dependencies: [
                .product(name: "CVBuilder", package: "cvbuilder"),
            ]
        ),
    ]
)
