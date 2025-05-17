// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "microbit",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "microbit", targets: ["microbit"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-mmio",
            branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "microbit",
            dependencies: [
                "Device", "Support",
            ]),
        .target(
            name: "Device",
            dependencies: [
                .product(name: "MMIO", package: "swift-mmio")
            ]),
        .target(name: "Support"),
    ]
)
