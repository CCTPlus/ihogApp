//
//  PreviewList.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct PreviewList: ViewModifier {
  func body(content: Content) -> some View {
    List {
      content
    }
  }
}

extension View {
  func previewList() -> some View {
    modifier(PreviewList())
  }
}

#Preview {
  Group {
    Text("Hello")
    Text("World")
  }
  .previewList()
}
