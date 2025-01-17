//
//  ShowEntity.Modifiers.swift
//  iHog
//
//  Created by Jay Wilson on 1/3/25.
//

import Models
import SwiftData
import SwiftUI

@available(iOS 18.0, *)
struct ShowEntityPreviewModifier: PreviewModifier {
  static func makeSharedContext() async throws -> ModelContainer {
    return ShowEntity.previewWithNotes
  }

  func body(content: Content, context: ModelContainer) -> some View {
    content
      .modelContainer(context)
  }
}
