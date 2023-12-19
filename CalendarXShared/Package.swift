// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalendarXShared",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CalendarXShared",
            targets: ["CalendarXShared"]),
    ],
    targets: [
        .target(
            name: "CalendarXShared",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
