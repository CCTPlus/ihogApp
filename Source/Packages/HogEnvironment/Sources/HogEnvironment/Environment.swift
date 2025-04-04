//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import HogAnalytics
import HogData
import HogRouter
import SwiftUI

/// ViewmModifier to inject environment values into the view hierarchy.
struct EnvironmentModifier: ViewModifier {
  @Environment(\.analytics) var analytics
  @Environment(\.persistenceController) var persistence

  @Environment(HogRouter.self) var hogRouter

  public func body(content: Content) -> some View {
    content
      .environment(\.analytics, analytics)
      .environment(\.persistenceController, persistence)
      .environment(hogRouter)
  }
}

struct PreviewEnvironment: ViewModifier {
  @Environment(HogRouter.self) var hogRouter

  public func body(content: Content) -> some View {
    content
      .environment(\.analytics, HogAnalytics())
      .environment(
        \.persistenceController,
        HogPersistenceController(
          inMemory: true
        )
      )
      .environment(hogRouter)
  }
}

extension View {
  /// Adds environment values to a view
  public func withHogEnvironment() -> some View {
    modifier(EnvironmentModifier())
  }

  /// Adds environment values to a view for previews
  public func withPreviewEnvironment() -> some View {
    modifier(PreviewEnvironment())
  }
}
