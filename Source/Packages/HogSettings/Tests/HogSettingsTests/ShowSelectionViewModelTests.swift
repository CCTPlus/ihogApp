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

import AppRouter
import HogAnalytics
import HogData
import Testing

@testable import HogSettings

class ShowSelectionViewModelTests {

  var testPersistenceController: HogPersistenceController

  init() {
    testPersistenceController = HogPersistenceController(
      inMemory: true,
      inTesting: true
    )
  }

  /// Tests that if only a persistenceController is given, then that is set and the repository is also set
  @Test func setupWithJustPersistenceController() async throws {
    let viewModel = await ShowSelectionViewModel()
    await viewModel
      .setup(
        persistenceController: testPersistenceController,
        appRouter: AppRouter(),
        analytics: HogAnalytics()
      )

    await #expect(viewModel.persistenceController != nil)
    await #expect(viewModel.repository != nil)
  }

  @Test func fetchShowsNoShows() async throws {
    let mockRepository = await ShowMockRespository()
    let viewModel = await ShowSelectionViewModel()
    await viewModel
      .setup(
        persistenceController: testPersistenceController,
        appRouter: AppRouter(),
        repository: mockRepository,
        analytics: HogAnalytics()
      )
    await viewModel.fetchShows()
    await #expect(viewModel.shows.isEmpty == true)
  }

  @Test func fetchShows5Shows() async throws {
    let mockRepository = await ShowMockRespository(
      preloadedShows: Show.mockShows
    )
    let viewModel = await ShowSelectionViewModel()
    await viewModel
      .setup(
        persistenceController: testPersistenceController,
        appRouter: AppRouter(),
        repository: mockRepository,
        analytics: HogAnalytics()
      )
    await viewModel.fetchShows()
    await #expect(viewModel.shows.isEmpty == false)
    await #expect(viewModel.shows.count == 5)
  }

  @Test func changeShow() async throws {
    let mockRepository = await ShowMockRespository(
      preloadedShows: Show.mockShows
    )
    let viewModel = await ShowSelectionViewModel()
    let appRouter = await AppRouter()
    await viewModel
      .setup(
        persistenceController: testPersistenceController,
        appRouter: appRouter,
        repository: mockRepository,
        analytics: HogAnalytics()
      )
    await viewModel.fetchShows()
    let chosenShow = await viewModel.shows.first!
    try await viewModel.changeShow(show: chosenShow)
    await #expect(appRouter.showID == chosenShow.id)
  }
}
