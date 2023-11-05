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
            exclude: ["spm_sources/Public/NotificationPresenter.swift"],
            sources: ["spm_sources/Public/", "spm_sources/Private/"],
            publicHeadersPath: "spm_sources/Public/",
            cSettings: [
              .headerSearchPath("spm_sources/Private/"),
            ]),
    .target(name: "JDStatusBarNotification",
            dependencies: ["JDStatusBarNotificationObjC"],
            path: ".",
            sources: ["spm_sources/Public/NotificationPresenter.swift"],
            swiftSettings: [
              .define("JDSB_SPM_DEPLOYMENT"),
            ]),
  ]
)
