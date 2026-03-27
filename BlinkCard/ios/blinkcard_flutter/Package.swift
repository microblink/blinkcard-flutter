// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "blinkcard_flutter",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(name: "blinkcard-flutter", targets: ["blinkcard_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/BlinkCard/blinkcard-ios.git", exact: .init(3000, 0, 0))
    ],
    targets: [
        .target(
            name: "blinkcard_flutter",
            dependencies: [
                .product(name: "BlinkCardUX", package: "blinkcard-ios")
            ],
            resources: []
        )
    ]
)
