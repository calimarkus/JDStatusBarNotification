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
            exclude: [".spm_mirror/Public/NotificationPresenter.swift"],
            sources: [".spm_mirror/Public/", ".spm_mirror/Private/"],
            publicHeadersPath: ".spm_mirror/Public/",
            cSettings: [
              .headerSearchPath(".spm_mirror/Private/"),
            ]),
    .target(name: "JDStatusBarNotification",
            dependencies: ["JDStatusBarNotificationObjC"],
            path: ".",
            sources: [".spm_mirror/Public/NotificationPresenter.swift"],
            swiftSettings: [
              .define("JDSB_SPM_DEPLOYMENT"),
            ]),
  ]
)
