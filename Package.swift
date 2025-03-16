// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "microbit",
    products: [
        .library(
            name: "microbit",
            type: .static,
            targets: ["microbit"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-mmio",
            branch: "swift-embedded-examples")
    ],
    targets: [
        .target(
            name: "microbit",
            dependencies: [
                "Device", "Support"
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(["-no-allocations"])
            ]),
        .target(
            name: "Device",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio")
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(["-no-allocations"])
            ]),
        .target(name: "Support"),
    ]
)
