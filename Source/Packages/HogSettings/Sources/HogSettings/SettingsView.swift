//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/3/25 by @HeyJayWilson
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
import HogEnvironment
import HogRouter
import HogUtilities
import SwiftUI

public struct SettingsView: View {
  let showRepository: ShowRepository?

  public init(showRepository: ShowRepository? = nil) {
    self.showRepository = showRepository
  }

  // TODO: Think about iphone layout more
  public var body: some View {
    VStack {
      HStack {
        Text("User Settings")
        Text("Programmer settings")
          .containerRelativeFrame(.horizontal, count: 2, span: 1, spacing: 0)
        OpenSoundControlConfigView()
          .containerRelativeFrame(.horizontal, count: 2, span: 1, spacing: 0)
      }
      ShowSelectionView(repository: showRepository)
    }
  }
}

#Preview {
  @Previewable @State var hogRouter = HogRouter()

  SettingsView(
    showRepository: ShowMockRespository(preloadedShows: Show.mockShows)
  )
  .withPreviewEnvironment()
  .environment(hogRouter)
}
