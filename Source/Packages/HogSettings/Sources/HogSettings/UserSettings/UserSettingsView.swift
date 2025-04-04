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

struct User {
  var isPro: Bool
  var proSince: Date?
}

extension User {
  static let noProUser = User(isPro: false, proSince: nil)
  static let isProUser = User(isPro: true, proSince: .distantPast)
}

struct UserSettingsView: View {
  var user: User
  var body: some View {
    VStack {
      if user.isPro {
        HStack {
          // Premium Icon
          Image(systemName: "star.square.on.square")
            .foregroundStyle(.orange, .blue)
            .font(.title2)

          // Text Stack
          VStack(alignment: .leading, spacing: 4) {
            Text("Premium Subscriber")
              .font(.headline)
            if let proSince = user.proSince {
              Text("Since \(proSince.formatted(date: .abbreviated, time: .omitted))")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            }
          }
        }
      } else {
        Text("Be a **Pro**gramnmer")
      }
    }
    .frame(maxWidth: .infinity)
    .sectionDesign()
  }
}

#Preview {
  VStack(spacing: 16) {
    UserSettingsView(user: .noProUser)
    UserSettingsView(user: .isProUser)
  }
}
