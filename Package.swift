// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "LiteMark",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "LiteMark", targets: ["LiteMark"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "LiteMark",
            path: "Sources/LiteMark"
        )
    ]
)
