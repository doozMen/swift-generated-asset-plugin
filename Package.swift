// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-generated-asset-plugin",
  platforms: [.macOS(.v13), .iOS(.v13)],
  products: [
    .library(
      name: "UIComponents",
      targets: ["UIComponents"]),
    .library(name: "Foo", targets: ["Foo"])
  ],
  dependencies: [],
  targets: [
    // Generated assets and a swift file to access them
    .plugin(name: "GenerateColorAssets", capability: .buildTool()),
    .plugin(name: "ReuseGenerated", capability: .buildTool()),
    .executableTarget(name: "PluginGeneratedResources", plugins: ["GenerateColorAssets"] ),
    .target(name: "Foo", plugins: ["ReuseGenerated"]),
    .target(
      name: "UIComponents",
      plugins: ["GenerateColorAssets"]
    )
    ]
)
