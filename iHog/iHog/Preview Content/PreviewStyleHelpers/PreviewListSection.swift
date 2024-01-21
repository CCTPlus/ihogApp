//
//  PreviewListSection.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct PreviewListSection: ViewModifier {
  func body(content: Content) -> some View {
    List {
      Section {
        content
      }
    }
  }
}

extension View {
  func previewListSection() -> some View {
    modifier(PreviewListSection())
  }
}

#Preview {
  Group {
    Text("Hello")
    Text("World")
  }
  .previewListSection()
}
