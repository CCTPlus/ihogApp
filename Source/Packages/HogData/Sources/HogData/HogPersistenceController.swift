//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/1/25 by @HeyJayWilson
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
import Foundation
import HogUtilities

/// A controller that manages Core Data persistence and CloudKit synchronization
public final class HogPersistenceController: @unchecked Sendable {

  /// Preview instance for SwiftUI previews
  public static let preview = HogPersistenceController(inMemory: true)

  /// Container for persistence
  public let container: NSPersistentCloudKitContainer
  /// Old default URL
  var oldStoreURL: URL {
    let appSupport = FileManager.default
      .urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
      )
      .first!
    let storeURL = appSupport.appendingPathComponent("iHog.sqlite")
    HogLogger.log(category: .coreData).debug("Default Store URL: \(storeURL.absoluteString)")
    return storeURL
  }
  /// App Groups URL
  var sharedStoreURL: URL {
    let id = AppInfo.appGroup
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: id)!
    let storeURL = containerURL.appendingPathComponent("iHog.sqlite")
    HogLogger.log(category: .coreData).debug("App Group URL: \(storeURL.absoluteString)")
    return storeURL
  }

  public init(inMemory: Bool = false, inTesting: Bool = false) {

    container = NSPersistentCloudKitContainer(
      name: "iHog",
      managedObjectModel: HogData.model  // This should trigger our debug prints in HogData
    )

    guard let description = container.persistentStoreDescriptions.first else {
      HogLogger.log(category: .error).error("Could not get persistent store description")
      fatalError()
    }

    if inTesting {
      description.cloudKitContainerOptions = nil
    }

    if inMemory {
      description.url = URL(fileURLWithPath: "/dev/null")
      container.loadPersistentStores { (_, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true
      return  // Early return for preview mode
    }

    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

    HogLogger.log(category: .coreData)
      .debug("Core Data store found at \(description.url?.absoluteString ?? "NO STORE FOUND")")

    let originalCloudKitOptions = description.cloudKitContainerOptions

    // check if migration is needed
    let fileExists = (try? oldStoreURL.checkResourceIsReachable()) ?? false

    if !fileExists {
      HogLogger.log(category: .coreData).info("Migration to AppGroups is not needed")
      description.url = sharedStoreURL
    } else {
      // Turn off cloudkit to avoid duplicates
      description.cloudKitContainerOptions = nil
      HogLogger.log(category: .coreData).info("Migration to AppGroups is needed")
    }

    HogLogger.log(category: .coreData).debug("Store description before loading:")
    HogLogger.log(category: .coreData).debug("URL: \(description.url?.absoluteString ?? "none")")
    HogLogger.log(category: .coreData).debug("Options: \(description.options)")
    HogLogger.log(category: .coreData)
      .debug("Configuration: \(description.configuration ?? "none")")
    HogLogger.log(category: .coreData)
      .debug("CloudKit options: \(String(describing: description.cloudKitContainerOptions))")

    description
      .setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

    // Load persistent store first
    container.loadPersistentStores { (storeDescription, error) in
      HogLogger.log(category: .coreData)
        .info("Store loaded at:\(storeDescription.url?.absoluteString ?? "NO STORE FOUND")")
      if let error = error as NSError? {
        HogLogger.log(category: .coreData)
          .error("Failed to load store: \(error.localizedDescription)")
        HogLogger.log(category: .coreData).error("Error domain: \(error.domain)")
        HogLogger.log(category: .coreData).error("Error code: \(error.code)")
        HogLogger.log(category: .coreData).error("User info: \(error.userInfo)")
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    migrateStore(for: container, originalCloudKitOptions: originalCloudKitOptions)

    container.viewContext.automaticallyMergesChangesFromParent = true
  }

  func migrateStore(
    for container: NSPersistentCloudKitContainer,
    originalCloudKitOptions: NSPersistentCloudKitContainerOptions?
  ) {
    let coordinator = container.persistentStoreCoordinator
    guard let storeDescription = container.persistentStoreDescriptions.first else {
      HogLogger.log(category: .coreData)
        .error("Could not load store descriptions during migration from default to app groups")
      fatalError()
    }

    // check again to see if migration is needed
    guard coordinator.persistentStore(for: oldStoreURL) != nil else {
      HogLogger.log(category: .coreData).info("Migration not needed")
      return
    }

    // First unload the current store
    if let persistentStore = coordinator.persistentStore(for: oldStoreURL) {
      do {
        try coordinator.remove(persistentStore)
      } catch {
        HogLogger.log(category: .coreData).error("Failed to unload persistent store: \(error)")
        return
      }
    }

    // Now try to move the files
    do {
      if FileManager.default.fileExists(atPath: sharedStoreURL.path) {
        try FileManager.default.removeItem(at: sharedStoreURL)
      }
      try FileManager.default.moveItem(at: oldStoreURL, to: sharedStoreURL)

      // Also move WAL and SHM files if they exist
      let oldSHM = oldStoreURL.deletingLastPathComponent()
        .appendingPathComponent("\(container.name).sqlite-shm")
      let oldWAL = oldStoreURL.deletingLastPathComponent()
        .appendingPathComponent("\(container.name).sqlite-wal")
      let newSHM = sharedStoreURL.deletingLastPathComponent()
        .appendingPathComponent("\(container.name).sqlite-shm")
      let newWAL = sharedStoreURL.deletingLastPathComponent()
        .appendingPathComponent("\(container.name).sqlite-wal")

      if FileManager.default.fileExists(atPath: oldSHM.path) {
        try? FileManager.default.moveItem(at: oldSHM, to: newSHM)
      }
      if FileManager.default.fileExists(atPath: oldWAL.path) {
        try? FileManager.default.moveItem(at: oldWAL, to: newWAL)
      }
    } catch {
      HogLogger.log(category: .coreData)
        .error("Failed to move store files: \(error)")
      return
    }

    // Load the store at the new location
    storeDescription.url = sharedStoreURL
    storeDescription.cloudKitContainerOptions = originalCloudKitOptions
    container.loadPersistentStores { storeDescription, error in
      if let error {
        HogLogger.log(category: .coreData).error("Failed to load persistent store: \(error)")
        fatalError("Failed to load persistent store: \(error)")
      }
    }

    HogLogger.log(category: .coreData).info("Successfully migrated store")
  }
}
