import Foundation
import SwiftUI

@main
public struct PluginGeneratedResources {
  public private(set) var text = "Hello, World!"

  public static func main() {
    let color = Color("barColor", bundle: .module)
    print(color)
    let path = Bundle.module.path(forResource: "foo", ofType: "txt")
    let exists = FileManager.default.fileExists(atPath: path!)
    assert(exists, "generated file is missing")
    print(PluginGeneratedResources().text)
  }
}
