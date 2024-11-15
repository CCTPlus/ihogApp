//
//  Persistence.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import CoreData

struct PersistenceController {
  // app uses
  static let shared = PersistenceController()

  //preview uses
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
      let newItem = CDShowEntity(context: viewContext)
      newItem.dateCreated = Date()
      newItem.dateLastModified = Date()
      newItem.name = "TEST SHOW 101"
      newItem.id = UUID()
      newItem.note = "Show notes go here"

      let newObject = CDShowObjectEntity(context: viewContext)
      newObject.id = UUID()
      newObject.number = 1.2
      newObject.name = "All Stage Wash"
      newObject.objColor = "red"
      newObject.objType = "group"
      newObject.isOutlined = true
    }
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      Analytics.shared.logError(with: error, for: .coreData, level: .fatal)
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()

  let container: NSPersistentCloudKitContainer

  /// OLD default URL. Eventually this will be migrated from
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

  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "iHog")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }

    guard let description = container.persistentStoreDescriptions.first else {
      HogLogger.log(category: .error).error("Could not get persistent store description")
      Analytics.shared.logError(with: HogOSCError.notAbleToLoadStore, for: .coreData, level: .fatal)
      fatalError()
    }

    HogLogger.log(category: .coreData)
      .debug("✅ Core Data store found at \(description.url?.absoluteString ?? "NO STORE FOUND")")

    let originalCloudKitOptions = description.cloudKitContainerOptions

    // check if migration is needed
    let fileExists = (try? oldStoreURL.checkResourceIsReachable()) ?? false

    if !fileExists {
      HogLogger.log(category: .coreData).info("Migration to AppGroups is not needed")
      description.url = sharedStoreURL
    } else {
      // since the old url exists, turn off cloudkit to avoid duplicates
      description.cloudKitContainerOptions = nil
      HogLogger.log(category: .coreData).info("⚠️ Migration to AppGroups is needed")
    }

    // Load persistent store to start migrations

    container.loadPersistentStores { (storeDescription, error) in
      HogLogger.log(category: .coreData)
        .info("Store loaded at:\(storeDescription.url?.absoluteString ?? "NO STORE FOUND")")
      if let error = error as NSError? {
        Analytics.shared.logError(with: error, for: .coreData, level: .fatal)
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
      Analytics.shared.logError(with: HogOSCError.notAbleToLoadStore, for: .coreData, level: .fatal)
      HogLogger.log(category: .coreData)
        .error("Could not load store descriptions during migration from default to app groups")
      fatalError()
    }
    // check again to see if migration is needed
    guard coordinator.persistentStore(for: oldStoreURL) != nil else {
      HogLogger.log(category: .coreData).info("Migration not needed")
      return
    }
    // Replace persistent stores
    do {
      try coordinator.replacePersistentStore(
        at: sharedStoreURL,
        withPersistentStoreFrom: oldStoreURL,
        type: .sqlite
      )
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .fatal)
      HogLogger.log(category: .coreData)
        .error("Something went wrong during migration of the store: \(error, privacy: .public)")
      fatalError("Something went wrong during migration of the store \(error)")
    }

    // Delete the old store. Can delete safely since if there's an error, the app fatal errors and crashes
    do {
      try coordinator.destroyPersistentStore(at: oldStoreURL, type: .sqlite)
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .fatal)
      HogLogger.log(category: .coreData)
        .log("Something went wrong deleting the old store: \(error)")
      fatalError("Something went wrong deleting the old store: \(error)")
    }

    NSFileCoordinator(filePresenter: nil)
      .coordinate(
        writingItemAt: oldStoreURL.deletingLastPathComponent(),
        options: .forDeleting,
        error: nil
      ) { url in
        try? FileManager.default.removeItem(at: oldStoreURL)
        try? FileManager.default.removeItem(
          at: oldStoreURL.deletingLastPathComponent()
            .appendingPathComponent("\(container.name).sqlite-shm")
        )
        try? FileManager.default.removeItem(
          at: oldStoreURL.deletingLastPathComponent()
            .appendingPathComponent("\(container.name).sqlite-wal")
        )
        try? FileManager.default.removeItem(
          at: oldStoreURL.deletingLastPathComponent().appendingPathComponent("ckAssetFiles")
        )
      }

    // unload the store and load it asgain with the new stuff
    if let persistentStore = container.persistentStoreCoordinator.persistentStores.first {
      do {
        try container.persistentStoreCoordinator.remove(persistentStore)
      } catch {
        HogLogger.log(category: .coreData).error("Failed to unload persistent store: \(error)")
      }
    }

    storeDescription.url = sharedStoreURL
    storeDescription.cloudKitContainerOptions = originalCloudKitOptions
    container.loadPersistentStores { storeDescription, error in
      if let error {
        HogLogger.log(category: .coreData).error("Failed to load persistent store: \(error)")
        fatalError("Failed to load persistent store: \(error)")
      }
    }

    HogLogger.log(category: .coreData).info("Successfully migrated store 🎉")
  }
}
