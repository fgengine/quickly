// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Quickly",
    platforms: [
        .iOS(.v10),
        .macOS(.v11)
    ],
    products: [
        .library(name: "Quickly", type: .static, targets: [ "Quickly" ]),
        .library(name: "QuicklyDynamic", type: .dynamic, targets: [ "Quickly" ])
    ],
    targets: [
        .target(
            name: "Quickly",
            dependencies: [ .target(name: "QuicklyObjC") ],
            path: "Quickly"
        ),
        .target(
            name: "QuicklyObjC",
            path: "QuicklyObjC",
            publicHeadersPath: "Public"
        )
    ]
)
