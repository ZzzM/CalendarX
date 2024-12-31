// swift-tools-version:5.9
import PackageDescription

let version = "0.0.1"

let package = Package(
    name: "CalendarXLib",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CalendarXLib",
            targets: ["CalendarXLib"]
        )
    ],
    targets: [
        .target(
            name: "CalendarXLib",
            path: "Sources",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        )
    ]
)
