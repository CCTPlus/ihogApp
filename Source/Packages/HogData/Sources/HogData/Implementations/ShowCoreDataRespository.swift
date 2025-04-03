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
// Copyright©t 2025 CCT Plus LLC. All rights reserved.
//

import CoreData
import HogUtilities

public struct ShowCoreDataRespository: ShowRepository {

  let persistenceController: HogPersistenceController

  public init(persistenceController: HogPersistenceController) {
    self.persistenceController = persistenceController
  }

  /// Creates a new show with the given name
  /// - Parameter name: Name of the show
  /// - Returns: The created Show object
  public func createShow(name: String, icon: String) async throws -> Show {
    let context = persistenceController.container.newBackgroundContext()

    let show = CDShowEntity(context: context)
    show.id = UUID()
    show.name = name.isEmpty ? "New Show" : name
    show.dateCreated = Date()
    show.icon = icon.isEmpty ? "folder" : icon

    try await context.perform {
      try context.save()
    }

    return Show(cdEntity: show)
  }

  /// Retrieves a show with the specified ID
  /// - Parameter id: UUID of the show to retrieve
  /// - Returns: The Show object if found
  public func getShow(id: UUID) async throws -> Show {
    let context = persistenceController.container.newBackgroundContext()
    let fetchRequest = CDShowEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    var fetchedShow: CDShowEntity?
    try await context.perform {
      fetchedShow = try context.fetch(fetchRequest).first
    }

    guard let show = fetchedShow else {
      throw ShowError.notFound
    }

    return Show(cdEntity: show)
  }

  /// Changes the name of an existing show
  /// - Parameter newName: New name for the show
  public func changeName(newName: String) async throws -> Show {
    let context = persistenceController.container.newBackgroundContext()
    let fetchRequest = CDShowEntity.fetchRequest()

    var fetchedShow: CDShowEntity?
    try await context.perform {
      fetchedShow = try context.fetch(fetchRequest).first
    }

    guard let show = fetchedShow else {
      throw ShowError.notFound
    }

    show.name = newName
    try await context.perform {
      try context.save()
    }

    return Show(cdEntity: show)
  }

  /// Deletes a show with the specified ID
  /// - Parameter id: UUID of the show to delete
  public func deleteShow(id: UUID) async throws {
    let context = persistenceController.container.newBackgroundContext()
    let fetchRequest = CDShowEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    var fetchedShow: CDShowEntity?
    try await context.perform {
      fetchedShow = try context.fetch(fetchRequest).first
    }

    guard let show = fetchedShow else {
      throw ShowError.notFound
    }

    context.delete(show)
    try await context.perform {
      try context.save()
    }
  }

  public func fetchShows() async throws -> [Show] {
    let context = persistenceController.container.newBackgroundContext()
    let fetchRequest = CDShowEntity.fetchRequest()

    var fetchedShows: [CDShowEntity] = []
    try await context.perform {
      fetchedShows = try context.fetch(fetchRequest)
    }

    return fetchedShows.map({ Show(cdEntity: $0) })
  }
}

/// Custom error types for Show operations
enum ShowError: Error {
  case notFound
}
