// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MovieAppTCA",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MovieAppTCA_Core",
            targets: ["MovieAppTCA_Core"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MovieAppTCA_Core",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            path: "MovieAppTCA/Core"
        )
    ]
) 