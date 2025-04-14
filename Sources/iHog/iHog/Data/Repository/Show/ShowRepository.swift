//
//  ShowRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation
import SwiftData
import SwiftUI

protocol ShowRepository {
  /// Creates a show given the name and icon
  func createShow(name: String, icon: String) async throws -> Show
  /// Gets show by ID
  func getShow(by id: UUID) async throws -> Show
  /// Gets all the shows a user has
  func getAllShows() async throws -> [Show]
  /// Delete a show for a given ID
  func deleteShow(by id: UUID) async throws
  /// Deletes all shows
  func deleteAll() async throws
  /// Returns the number of shows a user has
  func getCountOfShows() async throws -> Int
}

extension ShowRepository {
  func notifyCreatedShow(show: Show) {
    NotificationCenter.default.post(name: .didSaveShow, object: show)
  }
}
