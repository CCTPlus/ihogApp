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
// Copyright©t 2025 CCT Plus LLC. All rights reserved.
//

import CoreData
import HogUtilities
import Testing

@testable import HogData

class ShowCoreDataReposityTests {
  /// The persistence controller used for in-memory Core Data storage during tests
  let persistenceController: HogPersistenceController

  init() {
    self.persistenceController = HogPersistenceController(inMemory: true)
  }

  deinit {
    // Clean up any test data by deleting all show entity objects
    let context = persistenceController.container.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
      entityName: "ShowEntity"
    )
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
      try context.execute(deleteRequest)
      try context.save()
    } catch {
      print("Error cleaning up test data: \(error)")
    }
  }

  @Test("Test creating a show")
  func createShowWithName() async throws {
    let repo = ShowCoreDataRespository(
      persistenceController: persistenceController
    )

    let createdShow = try await repo.createShow(name: "The Era's Tour", icon: "guitar")

    #expect(createdShow.name == "The Era's Tour")
    #expect(createdShow.icon == "guitar")
  }

  @Test("No show name or icon provided")
  func createShowWithNoNameNoIcon() async throws {
    let repo = ShowCoreDataRespository(
      persistenceController: persistenceController
    )

    let createdShow = try await repo.createShow(name: "", icon: "")

    #expect(createdShow.name == "New Show")
    #expect(createdShow.icon == "folder")
  }

  @Test("Ability to fetch shows")
  func fetchShows() async throws {
    let repo = ShowCoreDataRespository(persistenceController: persistenceController)
    // I don't like this but I know createShow works due to the test above
    for i in 0..<10 {
      _ = try await repo.createShow(name: "Test \(i)", icon: "folder")
    }

    let fetchedShows = try await repo.fetchShows()
    #expect(fetchedShows.count == 10)
  }

  @Test("Ability to get a specific show")
  func getShow() async throws {
    let repo = ShowCoreDataRespository(persistenceController: persistenceController)
    // I don't like this but I know createShow works due to the test above
    let createdShow = try await repo.createShow(name: "Test Show", icon: "folder")

    let foundShow = try await repo.getShow(id: createdShow.id)
    #expect(foundShow.name == "Test Show")
    #expect(foundShow.id == createdShow.id)
  }
}
