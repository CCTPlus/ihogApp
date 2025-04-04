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

class HogPersistenceControllerTests {
  /// File manager instance for file operations
  let fileManager: FileManager

  /// Test URLs for stores
  var testOldStoreURL: URL {
    let appSupport =
      fileManager.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
      )
      .first!
    return appSupport.appendingPathComponent("iHog.sqlite")
  }

  /// Shared store URL for tests
  var sharedStoreURL: URL {
    let id = AppInfo.appGroup
    let containerURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: id
    )!
    return containerURL.appendingPathComponent("iHog.sqlite")
  }

  init() {
    self.fileManager = .default
    // Clean up any leftover files from previous test runs
    cleanup()
  }

  deinit {
    cleanup()
  }

  private func cleanup() {
    try? fileManager.removeItem(at: testOldStoreURL)
    try? fileManager.removeItem(at: sharedStoreURL)

    // Also clean up auxiliary files
    try? fileManager.removeItem(
      at: testOldStoreURL.deletingLastPathComponent()
        .appendingPathComponent("iHog.sqlite-shm")
    )
    try? fileManager.removeItem(
      at: testOldStoreURL.deletingLastPathComponent()
        .appendingPathComponent("iHog.sqlite-wal")
    )
    try? fileManager.removeItem(
      at: sharedStoreURL.deletingLastPathComponent()
        .appendingPathComponent("iHog.sqlite-shm")
    )
    try? fileManager.removeItem(
      at: sharedStoreURL.deletingLastPathComponent()
        .appendingPathComponent("iHog.sqlite-wal")
    )
  }

  @Test("Verifies store migration from old location to app groups")
  func testStoreMigration() async throws {
    // Create store at old location
    let storeDescription = NSPersistentStoreDescription(url: testOldStoreURL)
    // Enable history tracking to match production configuration
    storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

    let container = NSPersistentContainer(
      name: "iHog",
      managedObjectModel: HogData.model
    )
    container.persistentStoreDescriptions = [storeDescription]

    // Load the store synchronously since we need it for setup
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      container.loadPersistentStores { _, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }

    // Create controller with testing flag
    let controller = HogPersistenceController(inTesting: true)

    // Get the actual shared store URL from the controller
    let foundSharedStoreURL = controller.sharedStoreURL

    #expect(
      !fileManager.fileExists(atPath: testOldStoreURL.path),
      "Old store should be deleted after migration"
    )
    #expect(
      foundSharedStoreURL.path == sharedStoreURL.path,
      "Store should be using app group URL"
    )

    // Check store configuration
    let description = controller.container.persistentStoreDescriptions.first
    #expect(description?.type == NSSQLiteStoreType, "Store type should be SQLite")
  }

  @Test("Verifies container initialization with correct model")
  func testContainerInitialization() throws {
    let controller = HogPersistenceController(inTesting: true)
    #expect(controller.container.managedObjectModel == HogData.model)
    #expect(controller.container.persistentStoreDescriptions.count == 1)
  }
}
