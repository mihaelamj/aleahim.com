// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Publish",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "Publish",
            targets: ["Publish"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .executableTarget(
            name: "Publish",
            dependencies: ["Publish"]
        )
    ]
)