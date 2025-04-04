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
import HogRouter
import HogUtilities
import SwiftUI

struct ShowSelectionView: View {
  @Environment(\.persistenceController) var persistenceController
  @Environment(\.analytics) var analytics
  @Environment(HogRouter.self) var hogRouter

  @State private var viewModel = ShowSelectionViewModel()

  // Mainly for passing in a repository for testing purposes.
  var repository: ShowRepository? = nil

  let columns = Array(
    repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
    count: 3
  )

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
    ScrollView {
      LazyVGrid(columns: columns, spacing: 24) {
        ForEach(viewModel.shows) { show in
          Button {
            change(to: show)
          } label: {
            buttonLabel(icon: show.icon, name: show.name)
          }
        }
        Button {
          //TODO: IMPLEMENT CREATE SHOW
          fatalError("Implement")
        } label: {
          buttonLabel(icon: "folder.badge.plus.fill", name: "New Show")
        }
        .tint(.green)
      }
    }
    .scrollBounceBehavior(.basedOnSize)
  }

  @ViewBuilder
  func buttonLabel(icon: String, name: String) -> some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.largeTitle)
        .bold()
      Text(name)
        .font(.headline)
        .tint(.primary)
    }
    .frame(maxWidth: 100)
  }

  func setupView() async {
    viewModel
      .setup(
        persistenceController: persistenceController,
        hogRouter: hogRouter,
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
  VStack {
    ShowSelectionView(
      repository: ShowMockRespository(preloadedShows: Show.mockShows)
    )
  }
  .environment(HogRouter())
  .environment(\.persistenceController, HogPersistenceController(inMemory: true))
  //  .environment(\.analytics, HogAnalytics())
}
