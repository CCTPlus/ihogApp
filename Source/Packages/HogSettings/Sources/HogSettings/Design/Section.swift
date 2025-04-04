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

import SwiftUI

struct SectionDesign: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(.ultraThickMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .padding(.vertical, 4)
  }
}

extension View {
  func sectionDesign() -> some View {
    modifier(SectionDesign())
  }
}
