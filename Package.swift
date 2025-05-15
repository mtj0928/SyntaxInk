// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SyntaxInk",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8), .visionOS(.v1)],
    products: [
        .library(name: "SwiftSyntaxInk", targets: ["SwiftSyntaxInk"]),
        .library(name: "SyntaxInk", targets: ["SyntaxInk"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftSyntaxInk",
            dependencies: [
                "SyntaxInk",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
        .target(name: "SyntaxInk"),
        .testTarget(name: "SyntaxInkTests", dependencies: ["SyntaxInk"]),
    ]
)
