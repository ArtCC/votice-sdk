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
            name: "Votice",
            targets: ["Votice"]
        )
    ],
    targets: [
        .target(
            name: "Votice",
            path: "Sources/Votice"
        ),
        .testTarget(
            name: "VoticeTests",
            dependencies: ["Votice"],
            path: "Tests/VoticeTests"
        )
    ]
)
