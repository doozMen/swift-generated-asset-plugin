
import Foundation
import PackagePlugin

enum Error: Swift.Error {
  case missingAssetSwiftFile
  case missingUIComponents
}

@main
struct ReuseGenerated: BuildToolPlugin {

  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {

    print("📦 reuse generated started")
    guard let uiComponents = try context.package.targets(named: ["UIComponents"]).first as? SwiftSourceModuleTarget else {
      throw Error.missingUIComponents
    }
    print("Did find files in UIComponents")

    print(uiComponents.sourceFiles.map { $0.path.string}.joined(separator: "\n"))

    print("---")

    guard let swiftAssetFile = (uiComponents.sourceFiles.first { $0.path.lastComponent == "Assets.swift"}) else {
      throw Error.missingAssetSwiftFile
    }

    let output = context.pluginWorkDirectory.appending("Assets.swift")

    return [
      .prebuildCommand(
        displayName: "📦 Generate new content based on generated source code of other target",
        executable: .init("/usr/bin/touch"),
        arguments: [output.string],
        outputFilesDirectory: context.pluginWorkDirectory)
    ]
  }

}
