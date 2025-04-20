//
//  BoardEntity.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation
import SwiftData

/// Managed model for storing board data in SwiftData and syncing with CloudKit.
/// Represents a board that can contain multiple items and belongs to a show.
/// All properties are optional to support CloudKit sync.
@Model final class BoardEntity {
  /// Unique identifier for the board
  var id: UUID?

  /// Display name of the board
  var name: String?

  /// Reference to the show this board belongs to
  var showID: UUID?

  /// X coordinate of the last pan offset, stored separately for CloudKit compatibility
  var lastPanOffsetX: Double?

  /// Y coordinate of the last pan offset, stored separately for CloudKit compatibility
  var lastPanOffsetY: Double?

  /// Last zoom scale applied to the board
  var lastZoomScale: Double?

  /// Timestamp of the last modification, auto-updates on property changes
  var dateLastModified: Date?

  /// Items placed on this board, cascade deleted when board is removed
  @Relationship(deleteRule: .cascade, inverse: \BoardItemEntity.board)
  var items: [BoardItemEntity]?

  /// Reference to the show entity this board belongs to
  var show: ShowEntity?

  init(
    id: UUID = UUID(),
    name: String? = nil,
    showID: UUID? = nil,
    lastPanOffsetX: Double? = nil,
    lastPanOffsetY: Double? = nil,
    lastZoomScale: Double? = nil,
    dateLastModified: Date? = .now,
    items: [BoardItemEntity]? = nil,
    show: ShowEntity? = nil
  ) {
    self.id = id
    self.name = name
    self.showID = showID
    self.lastPanOffsetX = lastPanOffsetX
    self.lastPanOffsetY = lastPanOffsetY
    self.lastZoomScale = lastZoomScale
    self.dateLastModified = dateLastModified
    self.items = items
    self.show = show
  }
}
