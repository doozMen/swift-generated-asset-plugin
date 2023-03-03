
import Foundation
import PackagePlugin

// MARK: - Error

enum Error: Swift.Error {
  case missingLizardFolder
  case couldNotCreateFile(path: Path)
}

@main
struct GenerateColorAssets: BuildToolPlugin {

  // MARK: Internal

  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    // Print a message to indicate that the function has started
    print("📦 generate-color-asset-catalog on \(target.name)")

    // Create the output directory for the color asset catalog
    let assets = context.pluginWorkDirectory.appending(subpath: "assets.xcassets")
    try createColorAssetCatalogOutputDirectoryIfNeeded(at: assets)


    // Determine the color sets that need to be created
    let colorSets = Set(["fooColor", "barColor"])

    // Create the output files for the color sets
    try createOutputFilesForColorSets(colorSets: colorSets, assetsDirectory: assets)

    // Just for testing also add an empty file
    let fooTextFile = context.pluginWorkDirectory.appending("foo.txt")
    let swiftAssetFile = context.pluginWorkDirectory.appending("Assets.swift")
    try FileManager.default.createFileIfNeeded(atPath: swiftAssetFile)
    // just as an example

    let swiftAssets = """
    import SwiftUI

    struct Assets {
      static let fooColor = Color("fooColor", bundle: .module)
      static let barColor = Color("barColor", bundle: .module)
    }
    """

    try swiftAssets.write(to: .init(fileURLWithPath: swiftAssetFile.string), atomically: true, encoding: .utf8)

    return [
      .buildCommand(
        displayName: "Generating empty file",
        executable: .init("/usr/bin/touch"),
        arguments: [fooTextFile.string],
        // ⚠️ It is important to add only the assets and not the individual Content.json files here.
        outputFiles: [fooTextFile, assets, swiftAssetFile]
      )
    ]
  }

  func createColorAssetCatalogOutputDirectoryIfNeeded(at assetsDirectory: Path) throws {
    guard !fileManager.folderExists(atPath: assetsDirectory.string) else {
      return
    }
    try fileManager.createDirectory(atPath: assetsDirectory.string, withIntermediateDirectories: false)
  }

  // Create the output files for the color sets
  func createOutputFilesForColorSets(colorSets: Set<String>, assetsDirectory: Path) throws {
    try colorSets.forEach { colorSet in
      let outputFolderPath = assetsDirectory.appending(subpath: "\(colorSet).colorset")
      let outputFilePath = outputFolderPath.appending(subpath: "Contents.json")

      guard !fileManager.folderExists(atPath: outputFolderPath.string) else {
        return
      }

      try fileManager.createDirectory(atPath: outputFolderPath.string, withIntermediateDirectories: false)
      fileManager.createFile(atPath: outputFilePath.string, contents: colorJSON.data(using: .utf8))
    }
  }

  // MARK: Private

  private let fileManager = FileManager.default

}

let colorJSON = """
{
  "token" : "buttonBackgroundSecondaryActiveFill",
  "info" : {
    "version" : 1,
    "author" : "chameleon"
  },
  "colors" : [
    {
      "idiom" : "universal",
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "red" : 1,
          "alpha" : 1,
          "blue" : 0,
          "green" : 0
        }
      },
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "light"
        }
      ]
    },
    {
      "idiom" : "universal",
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "red" : 0,
          "alpha" : 1,
          "blue" : 0,
          "green" : 1
        }
      },
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ]
    }
  ]
}
"""

extension FileManager {
  func folderExists(atPath path: String) -> Bool {
    var isDirectory: ObjCBool = false
    let exists = fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }
  func createFileIfNeeded(atPath path: Path) throws {
    guard !FileManager.default.fileExists(atPath: path.string) else {
      return
    }
    guard FileManager.default.createFile(atPath: path.string, contents: nil) else {
      throw Error.couldNotCreateFile(path: path)
    }

  }
}
