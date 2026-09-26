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
        .binaryTarget(
            name: "SovereignPlayerCore",
            url: "https://github.com/TheSPST/sovereign-player-swift-sdk/releases/download/v1.0.0/SovereignPlayerCore.xcframework.zip",
            checksum: "6205e0deb311a7ba80ffa4094d6ebee591a4bff762a8e4f23487751f40574fd5"
            // For local development without downloading, use: path: "Frameworks/SovereignPlayerCore.xcframework"
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
