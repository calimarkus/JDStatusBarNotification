// swift-tools-version:5.7
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
            path: "spm_sources",
            exclude: ["Public/NotificationPresenter.swift"],
            sources: ["Public/", "Private/"],
            publicHeadersPath: "Public/",
            cSettings: [
              .headerSearchPath("Private/"),
            ]),
    .target(name: "JDStatusBarNotification",
            dependencies: ["JDStatusBarNotificationObjC"],
            path: "spm_sources",
            sources: ["Public/NotificationPresenter.swift"],
            swiftSettings: [
              .define("JDSB_SPM_DEPLOYMENT"),
            ]),
  ]
)
