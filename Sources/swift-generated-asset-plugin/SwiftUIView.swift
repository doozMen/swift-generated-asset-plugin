//
//  SwiftUIView.swift
//  
//
//  Created by Stijn Willems on 24/02/2023.
//

import SwiftUI

public struct SwiftUIView: View {

  public init() {}
  
  public var body: some View {
    VStack {
      Text("Hello, World!")
      // In light shows text in red, dark in green
        .foregroundColor(Color("fooColor", bundle: .module))
      Button("print color") {
        print(Color("fooColor", bundle: .module))
        // lets try to print contents of text file
        // printing only works with xcode 14.3
        let url = Bundle.module.url(forResource: "foo", withExtension: "txt")!
        print(try! String(contentsOf: url))
      }
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIView()
  }
}
