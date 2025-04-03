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

import Foundation

/// Repository protocol defining the contract for Show data management
protocol ShowRepository {
  /// Creates a new show with given name and icon
  /// - Parameters:
  ///   - name: Name of the show
  ///   - icon: Icon identifier for the show
  /// - Returns: The newly created Show
  func createShow(name: String, icon: String) async throws -> Show

  /// Retrieves a show by its unique identifier
  /// - Parameter id: UUID of the show to retrieve
  /// - Returns: The requested Show
  func getShow(id: UUID) async throws -> Show

  /// Retrieve all shows
  func fetchShows() async throws -> [Show]

  /// Updates the name of a show
  /// - Parameter newName: New name for the show
  /// - Returns: The updated Show
  func changeName(newName: String) async throws -> Show

  /// Update the last opened date of a Show
  /// - Parameter showId: UUID of the show to update
  /// - Returns: The updated Show
  func updateLastOpenedDate(id: UUID) async throws -> Show

  /// Deletes a show with the specified ID
  /// - Parameter id: UUID of the show to delete
  func deleteShow(id: UUID) async throws

  // TODO: Implement the following methods
  /// Retrieves all objects associated with a show
  /// - Parameter showId: UUID of the show to get objects for
  /// - Returns: Array of ShowObjects belonging to the show
  //    func getAllObjects(forShow showId: UUID) async throws -> [ShowObject]

  /// Adds a new object to a show
  /// - Parameters:
  ///   - object: The ShowObject to add
  ///   - showId: UUID of the show to add the object to
  /// - Returns: The added ShowObject
  //    func addObject(_ object: ShowObject, toShow showId: UUID) async throws -> ShowObject
}
