// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SkillsMate",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SkillsMate", targets: ["SkillsMateApp"])
    ],
    targets: [
        .executableTarget(
            name: "SkillsMateApp",
            path: "Sources/SkillsMateApp"
        ),
        .testTarget(
            name: "SkillsMateAppTests",
            dependencies: ["SkillsMateApp"],
            path: "Tests/SkillsMateAppTests"
        )
    ]
)
