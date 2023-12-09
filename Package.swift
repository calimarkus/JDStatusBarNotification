// swift-tools-version:5.7
// (minimum version of Swift required to build this package)

import PackageDescription

let package = Package(
  name: "JDStatusBarNotification",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "JDStatusBarNotification", targets: ["JDStatusBarNotification"]),
  ],
  targets: [
    .target(name: "JDStatusBarNotification", path: "JDStatusBarNotification/"),
  ]
)
