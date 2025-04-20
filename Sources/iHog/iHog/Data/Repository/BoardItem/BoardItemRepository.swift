//
//  BoardItemRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import TelemetryDeck

/// Protocol defining the interface for board item operations
/// Provides methods for creating, reading, updating, and deleting board items
protocol BoardItemRepository {
  /// Places a new item on a board
  /// - Parameters:
  ///   - boardID: The ID of the board to place the item on
  ///   - itemType: The type of the item to place
  ///   - referenceID: The ID of the show object to reference
  ///   - position: The position to place the item at (relative to board center)
  ///   - size: The size of the item in grid units (minimum 2×2)
  /// - Returns: The newly created board item
  /// - Throws: An error if the item could not be created
  func placeItem(
    boardID: UUID,
    itemType: ShowObjectType,
    referenceID: UUID,
    position: CGPoint,
    size: CGSize
  ) async throws -> BoardItem

  /// Gets all items for a board, sorted by position
  /// - Parameter boardID: The ID of the board to get items for
  /// - Returns: An array of board items, sorted by positionY ascending, then positionX ascending
  /// - Throws: An error if the items could not be retrieved
  func getItems(for boardID: UUID) async throws -> [BoardItem]

  /// Updates an item's position
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - position: The new position for the item (must snap to 44×44 point grid)
  /// - Returns: The updated board item
  /// - Throws: An error if the item could not be updated
  func updateItemPosition(id: UUID, position: CGPoint) async throws -> BoardItem

  /// Updates an item's size
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - size: The new size for the item (minimum 2×2 grid units)
  /// - Returns: The updated board item
  /// - Throws: An error if the item could not be updated
  func updateItemSize(id: UUID, size: CGSize) async throws -> BoardItem

  /// Deletes an item by its ID
  /// - Parameter id: The ID of the item to delete
  /// - Throws: An error if the item could not be deleted
  func deleteItem(id: UUID) async throws

  /// Updates an item's reference to a show object
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - referenceID: The ID of the new show object to reference
  /// - Returns: The updated board item
  /// - Throws: An error if the item could not be updated
  func updateItemReference(id: UUID, referenceID: UUID) async throws -> BoardItem
}

/// Errors specific to board item operations
enum BoardItemError: IdentifiableError, Error {
  case notFound
  case boardNotFound
  case showObjectNotFound

  var id: String {
    switch self {
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }
}
