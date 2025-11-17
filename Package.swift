// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LiteSurvey",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "LiteSurvey",
            targets: ["LiteSurvey"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "LiteSurvey",
            path: "./LiteSurvey.xcframework"
        )
    ]
)
