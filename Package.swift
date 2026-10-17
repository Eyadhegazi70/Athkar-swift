// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AthkarApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "AthkarApp", targets: ["AthkarApp"])
    ],
    targets: [
        .executableTarget(
            name: "AthkarApp",
            path: "."
        )
    ]
)
