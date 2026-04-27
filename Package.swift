// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "FlashLearn",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "FlashLearn",
            path: "Sources/FlashLearn"
        )
    ]
)
