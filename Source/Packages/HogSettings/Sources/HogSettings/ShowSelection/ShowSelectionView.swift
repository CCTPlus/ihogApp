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

import AppRouter
import HogAnalytics
import HogData
import HogUtilities
import SwiftUI

struct ShowSelectionView: View {
  @Environment(\.persistenceController) var persistenceController
  @Environment(\.analytics) var analytics
  @Environment(AppRouter.self) var appRouter

  @State private var viewModel = ShowSelectionViewModel()

  // Mainly for passing in a repository for testing purposes.
  var repository: ShowRepository? = nil

  var body: some View {
    if viewModel.repository == nil {
      ProgressView()
        .task {
          await setupView()
        }
    } else {
      content
    }
  }

  @ViewBuilder
  var content: some View {
    ForEach(viewModel.shows) { show in
      Button {
        change(to: show)
      } label: {
        buttonLabel(icon: show.icon, name: show.name)
      }
    }
  }

  @ViewBuilder
  func buttonLabel(icon: String, name: String) -> some View {
    HStack {
      Image(systemName: icon)
      Text(name)
    }
  }

  func setupView() async {
    viewModel
      .setup(
        persistenceController: persistenceController,
        appRouter: appRouter,
        repository: repository,
        analytics: analytics
      )
    await viewModel.fetchShows()
  }

  func change(to show: Show) {
    do {
      try viewModel.changeShow(show: show)
    } catch {
      HogLogger.log(category: .error).error("🚨 \(error)")
    }
  }
}

#Preview {
  List {
    ShowSelectionView(
      repository: ShowMockRespository(preloadedShows: Show.mockShows)
    )
  }
  .environment(AppRouter())
  .environment(\.persistenceController, HogPersistenceController(inMemory: true))
  //  .environment(\.analytics, HogAnalytics())
}
