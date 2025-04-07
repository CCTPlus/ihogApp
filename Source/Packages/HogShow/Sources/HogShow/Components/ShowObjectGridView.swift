//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/7/25 by @HeyJayWilson
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

import HogData
import SwiftUI

struct ShowObjectGridView: View {
  /// Array of show objects to display in the grid
  var showObjects: [ShowObject]

  var spacing: CGFloat = 8

  /// Grid layout that adapts to screen width with fixed item size
  private var columns: [GridItem] {
    [GridItem(.adaptive(minimum: 150, maximum: 150), spacing: spacing)]
  }

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: spacing) {
        ForEach(showObjects) { object in
          ZStack {
            HStack {
              Text(object.type.paletteLetter)
              Spacer()
              Text(object.number.formatted())
            }
            .foregroundStyle(.primary.opacity(0.8))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Text(object.name)
              .font(.headline)
          }
          .padding(8)
          .frame(width: 150, height: 150)
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.red)
              .strokeBorder(.primary.tertiary, lineWidth: 4)
          )
        }
      }
    }
    .contentMargins(16)
  }
}

#Preview {
  ShowObjectGridView(showObjects: ShowObject.mockShowObjects)
}
