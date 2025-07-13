// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Votice",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "VoticeSDK",
            targets: ["VoticeSDK"]
        )
    ],
    targets: [
        .target(
            name: "VoticeSDK",
            path: "Sources/Votice"
        ),
        .testTarget(
            name: "VoticeTests",
            dependencies: ["VoticeSDK"],
            path: "Tests/VoticeTests"
        )
    ]
)
