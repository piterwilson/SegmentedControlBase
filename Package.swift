// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SegmentedControlBase",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SegmentedControlBase",
            targets: ["SegmentedControlBase"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SegmentedControlBase",
            dependencies: [])
    ]
)
