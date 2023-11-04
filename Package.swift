// swift-tools-version:5.3
// (minimum version of Swift required to build this package)

import PackageDescription

let package = Package(
  name: "JDStatusBarNotification",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "JDStatusBarNotification",
             targets: ["JDStatusBarNotification", "JDStatusBarNotificationObjC"]),
  ],
  targets: [
    .target(name: "JDStatusBarNotificationObjC",
            path: ".",
            exclude: ["JDStatusBarNotification/Public/NotificationPresenter.swift"],
            sources: ["JDStatusBarNotification/Public/", "JDStatusBarNotification/Private/"],
            publicHeadersPath: "JDStatusBarNotification/Public/",
            cSettings: [
              .headerSearchPath("JDStatusBarNotification/Private/"),
            ]),
    .target(name: "JDStatusBarNotification",
            dependencies: ["JDStatusBarNotificationObjC"],
            path: ".",
            sources: ["JDStatusBarNotification/Public/NotificationPresenter.swift"],
            swiftSettings: [
              .define("JDSB_SPM_DEPLOYMENT"),
            ]),
  ]
)
