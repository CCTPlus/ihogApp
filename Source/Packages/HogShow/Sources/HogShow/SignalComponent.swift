//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/6/25 by @HeyJayWilson
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

struct SignalComponent: View {
  var body: some View {
    HStack {
      Circle()
        .fill(.gray)
        .frame(width: 24)
      Text("IN")
        .font(.caption)
        .monospaced()
        .padding(.trailing, 24)
      Text("OUT")
        .font(.caption)
        .monospaced()
      Circle()
        .fill(.gray)
        .frame(width: 24)
    }
    .padding(8)
    .background {
      Capsule(style: .continuous)
        .fill(.ultraThickMaterial)
    }
  }
}

#Preview {
  SignalComponent()
}
