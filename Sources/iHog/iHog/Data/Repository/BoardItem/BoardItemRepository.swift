import Foundation
import SwiftData
import SwiftUI

/// Protocol defining operations for managing board items
protocol BoardItemRepository {
  /// Fetches all board items for a given board ID
  /// - Parameter boardID: The ID of the board to fetch items for
  /// - Returns: An array of board items
  func fetchItems(for boardID: UUID) async throws -> [BoardItem]

  /// Creates a new board item for a specific board
  /// - Parameters:
  ///   - item: The board item to create
  ///   - boardID: The ID of the board this item belongs to
  func createItem(_ item: BoardItem, boardID: UUID) async throws -> BoardItem

  /// Updates an existing board item
  /// - Parameter item: The board item to update
  func updateItem(_ item: BoardItem) async throws

  /// Deletes a board item by ID
  /// - Parameter id: The ID of the board item to delete
  func deleteItem(by id: UUID) async throws

  /// Deletes all items for a given board
  /// - Parameter boardID: The ID of the board whose items should be deleted
  func deleteItems(for boardID: UUID) async throws
}
