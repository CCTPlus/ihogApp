//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

/// Core entity for managing show data persistence and synchronization.
/// This entity serves as the root container for all show-related data, including objects and boards.
/// Properties are optional to support CloudKit's partial sync model, where not all properties may be available during sync.
@Model final class ShowEntity {
  /// Timestamp when the show was first created in the app
  /// Used for sorting and filtering shows by creation date
  var dateCreated: Date?

  /// Timestamp of the most recent modification to any property
  /// Auto-updated by SwiftData to track changes for sync and UI updates
  var dateLastModified: Date?

  /// SF Symbol name for the show's icon
  /// Used in the UI to visually distinguish between different shows
  var icon: String?

  /// Unique identifier for the show
  /// Required for CloudKit sync and relationship management
  var id: UUID?

  /// Display name of the show
  /// Defaults to "New Show" to provide immediate feedback when creating a new show
  var name: String = "New Show"

  /// Optional notes about the show
  /// Used for additional context or documentation about the show's purpose
  var note: String?

  /// Collection of objects contained in this show
  @Relationship(deleteRule: .cascade, inverse: \ShowObjectEntity.show)
  var objects: [ShowObjectEntity]?

  /// Collection of boards contained in this show
  @Relationship(deleteRule: .cascade, inverse: \BoardEntity.show)
  var boards: [BoardEntity]?

  /// Creates a new show entity with optional initialization of all properties
  init(
    dateCreated: Date? = nil,
    dateLastModified: Date? = nil,
    icon: String? = nil,
    id: UUID = UUID(),
    name: String,
    note: String? = nil,
    objects: [ShowObjectEntity]? = nil,
    boards: [BoardEntity]? = nil
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.icon = icon
    self.id = id
    self.name = name
    self.note = note
    self.objects = objects
    self.boards = boards
  }
}
