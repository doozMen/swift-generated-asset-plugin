// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-generated-asset-plugin",
  platforms: [.macOS(.v13), .iOS(.v13)],
  products: [
    .library(
      name: "swift-generated-asset-plugin",
      targets: ["swift-generated-asset-plugin"]),
  ],
  dependencies: [],
  targets: [
    .plugin(name: "GenerateColorAssets", capability: .buildTool()),
    .target(
      name: "swift-generated-asset-plugin",
      dependencies: [],
      plugins: ["GenerateColorAssets"]
    )
    ]
)
