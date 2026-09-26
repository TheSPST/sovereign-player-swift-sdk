// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SovereignPlayerSDK",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SovereignPlayerSDK",
            targets: ["SovereignPlayerSDK", "SovereignPlayerCore"]
        ),
    ],
    targets: [
        // 🔒 Pre-compiled closed-source binary target containing proprietary Metal & NEON engines
        // For local development and repo bundling, this uses the embedded XCFramework path.
        // For production GitHub release tags, this can be swapped to remote URL + SHA256 checksum.
        .binaryTarget(
            name: "SovereignPlayerCore",
            path: "Frameworks/SovereignPlayerCore.xcframework"
        ),
        
        // 🌐 Public Swift wrapper exposing SwiftUI and AppKit/UIKit APIs
        .target(
            name: "SovereignPlayerSDK",
            dependencies: [
                "SovereignPlayerCore"
            ],
            path: "Sources/SovereignPlayerSDK"
        ),
        
        // 🧪 Automated Unit and Integration Tests
        .testTarget(
            name: "SovereignPlayerSDKTests",
            dependencies: [
                "SovereignPlayerSDK",
                "SovereignPlayerCore"
            ],
            path: "Tests/SovereignPlayerSDKTests"
        ),
    ]
)
