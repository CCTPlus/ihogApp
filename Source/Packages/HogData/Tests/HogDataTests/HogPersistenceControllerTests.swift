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

  init() {
    self.fileManager = .default
  }

  deinit {
    // Clean up test files
    try? fileManager.removeItem(at: testOldStoreURL)
    var sharedStoreURL: URL {
      let id = AppInfo.appGroup
      let containerURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: id
      )!
      let storeURL = containerURL.appendingPathComponent("iHog.sqlite")
      HogLogger.log(category: .coreData).debug("App Group URL: \(storeURL.absoluteString)")
      return storeURL
    }
    try? fileManager.removeItem(at: sharedStoreURL)
  }

  @Test("Verifies store migration from old location to app groups")
  func testStoreMigration() async throws {
    // Create store at old location
    let storeDescription = NSPersistentStoreDescription(url: testOldStoreURL)
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

    // Check migration
    #expect(
      !fileManager.fileExists(atPath: testOldStoreURL.path),
      "Old store should be deleted after migration"
    )

    // Get the actual shared store URL from the controller
    let sharedStoreURL = controller.sharedStoreURL
    #expect(
      fileManager.fileExists(atPath: sharedStoreURL.path),
      "New store should exist after migration"
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
