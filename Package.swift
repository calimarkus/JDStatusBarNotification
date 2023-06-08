// swift-tools-version:5.3
// (minimum version of Swift required to build this package)

import PackageDescription

let package = Package(
    name: "JDStatusBarNotification",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JDStatusBarNotification",
            targets: ["JDStatusBarNotification"]),
    ],
    targets: [
        .target(
            name: "JDStatusBarNotification",
            dependencies: [],
            path: ".",
            exclude: ["ExampleProject/"],
            sources: ["JDStatusBarNotification/"],
            publicHeadersPath: "JDStatusBarNotification/Public/",
            cSettings: [
                .headerSearchPath("JDStatusBarNotification/Private/"),
            ]),
    ]
)
