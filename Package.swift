// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SLSL",
    products: [
        .library(name: "SLSL4", targets: ["SLSL4"]),
        .executable(name: "SLSL4Fuzz", targets: ["SLSL4Fuzz"]),
        .executable(name: "SLSL4Benchmark", targets: ["SLSL4Benchmark"]),
    ],
    targets: [
        .target(name: "SLSL4", exclude: ["Note.md"]),
        .testTarget(name: "SLSL4Test", dependencies: ["SLSL4"]),
        .target(name: "SLSL4Fuzz", dependencies: ["SLSL4"]),
        .target(name: "SLSL4Benchmark", dependencies: ["SLSL4"]),
    ]
)
