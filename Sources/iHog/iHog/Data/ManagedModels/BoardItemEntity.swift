//
//  BoardItemEntity.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//
//

import Foundation
import SwiftData

/// Managed model for storing board item data in SwiftData and syncing with CloudKit.
/// Represents an item placed on a board that references a show object.
/// All properties are optional to support CloudKit sync.
@Model final class BoardItemEntity {
  /// Unique identifier for this board item
  /// Used for tracking and updating specific items
  var id: UUID?

  /// Identifier of the board this item belongs to
  /// Required for relationship management and filtering items by board
  var boardID: UUID?

  /// Type of the referenced show object
  /// Determines the visual style and behavior of the item
  var itemType: String?

  /// Identifier of the referenced show object
  /// Links this board item to its source object for data synchronization
  var referenceID: UUID?

  /// X position of the item's center relative to the board's center (0,0)
  /// Measured in points, with positive X right
  var positionX: Double?

  /// Y position of the item's center relative to the board's center (0,0)
  /// Measured in points, with positive Y up
  var positionY: Double?

  /// Width of the item in grid units
  /// Each grid unit is 44 points, with a minimum of 1
  var width: Double?

  /// Height of the item in grid units
  /// Each grid unit is 44 points, with a minimum of 1
  var height: Double?

  /// The board this item belongs to
  var board: BoardEntity?

  /// The show object this item references
  /// Used to access the object's properties and data
  var showObject: ShowObjectEntity?

  /// Creates a new board item entity with optional initialization of all properties
  /// All properties are optional to support CloudKit sync and partial data loading
  init(
    id: UUID? = nil,
    boardID: UUID? = nil,
    itemType: String? = nil,
    referenceID: UUID? = nil,
    positionX: Double? = nil,
    positionY: Double? = nil,
    width: Double? = nil,
    height: Double? = nil,
    board: BoardEntity? = nil,
    showObject: ShowObjectEntity? = nil
  ) {
    self.id = id
    self.boardID = boardID
    self.itemType = itemType
    self.referenceID = referenceID
    self.positionX = positionX
    self.positionY = positionY
    self.width = width
    self.height = height
    self.board = board
    self.showObject = showObject
  }
}
