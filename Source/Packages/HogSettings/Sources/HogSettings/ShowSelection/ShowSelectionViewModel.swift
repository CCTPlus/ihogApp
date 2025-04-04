//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/2/25 by @HeyJayWilson
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

import Foundation
import HogAnalytics
import HogData
import HogRouter
import HogUtilities

@Observable
@MainActor
final class ShowSelectionViewModel {
  var persistenceController: HogPersistenceController?
  var repository: ShowRepository?
  var hogRouter: HogRouter?
  var analytics: HogAnalytics?
  var shows: [Show] = []

  init() {}

  func setup(
    persistenceController: HogPersistenceController,
    hogRouter: HogRouter,
    repository: ShowRepository? = nil,
    analytics: HogAnalytics
  ) {
    self.persistenceController = persistenceController
    self.hogRouter = hogRouter
    self.analytics = analytics
    if let repository {
      self.repository = repository
    } else {
      self.repository = ShowCoreDataRespository(
        persistenceController: persistenceController
      )
    }
  }

  // Get all the shows
  nonisolated func fetchShows() async {
    guard let repository = await self.repository else { return }
    do {
      let foundShows = try await repository.fetchShows()
      await setShows(newShows: foundShows)
    } catch {
      // Must use await because the class is marked with @MainActor making
      // the property access asynchronous
      await analytics?.logError(with: error, for: .show, level: .critical)
      HogLogger.log(category: .error).error("🚨 \(error)")
    }
  }

  // Change the opened show to a new one
  func changeShow(show: Show) throws {
    HogLogger.log().info("Opening show to \(show.name)")
    guard let repository = repository else { return }
    Task {
      let updatedShow = try await repository.updateLastOpenedDate(id: show.id)
      HogLogger
        .log(category: .show)
        .info(
          "Opened show \(updatedShow.name) at \(updatedShow.dateLastOpened?.formatted() ?? "NO OPENED DATE SET")"
        )
    }
    hogRouter?.changeShow(to: show.id)
  }

  @MainActor
  private func setShows(newShows: [Show]) {
    shows = newShows
  }
}
