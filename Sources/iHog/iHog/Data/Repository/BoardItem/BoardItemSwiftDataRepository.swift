//
//  BoardItemSwiftDataRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import SwiftData

/// SwiftData implementation of BoardItemRepository
/// Manages board item persistence using SwiftData with grid-based positioning
@ModelActor
actor BoardItemSwiftDataRepository: BoardItemRepository {
  /// Places a new item on a board
  /// - Parameters:
  ///   - boardID: The ID of the board to place the item on
  ///   - itemType: The type of the item to place
  ///   - referenceID: The ID of the show object to reference
  ///   - position: The position to place the item at (relative to board center)
  ///   - size: The size of the item in grid units (minimum 2×2)
  /// - Returns: The newly created board item
  /// - Throws: BoardItemError if creation fails or board not found
  func placeItem(
    boardID: UUID,
    itemType: ShowObjectType,
    referenceID: UUID,
    position: CGPoint,
    size: CGSize
  ) async throws -> BoardItem {
    // Validate minimum size (2×2 grid units = 88×88 points)
    let validatedSize = CGSize(
      width: max(88, size.width),
      height: max(88, size.height)
    )

    // Find the board
    let boardDescriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    guard let board = try modelContext.fetch(boardDescriptor).first else {
      throw BoardItemError.boardNotFound
    }

    // Find the show object
    let objectDescriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == referenceID }
    )
    guard let showObject = try modelContext.fetch(objectDescriptor).first else {
      throw BoardItemError.showObjectNotFound
    }

    // Create and configure the entity
    let entity = BoardItemEntity(
      id: UUID(),
      boardID: boardID,
      itemType: itemType.rawValue,
      referenceID: referenceID,
      positionX: position.x,
      positionY: position.y,
      width: validatedSize.width,
      height: validatedSize.height,
      board: board,
      showObject: showObject
    )

    modelContext.insert(entity)
    try modelContext.save()

    return BoardItem(from: entity)
  }

  /// Gets all items for a board, sorted by position
  /// - Parameter boardID: The ID of the board to get items for
  /// - Returns: Array of board items sorted by Y ascending, then X ascending
  /// - Throws: BoardItemError if fetch fails
  func getItems(for boardID: UUID) async throws -> [BoardItem] {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate<BoardItemEntity> { $0.boardID == boardID },
      sortBy: [
        SortDescriptor(\.positionY),
        SortDescriptor(\.positionX),
      ]
    )

    let entities = try modelContext.fetch(descriptor)
    return entities.map { BoardItem(from: $0) }
  }

  /// Updates an item's position
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - position: The new position (snapped to 44×44 point grid)
  /// - Returns: The updated board item
  /// - Throws: BoardItemError if update fails or item not found
  func updateItemPosition(id: UUID, position: CGPoint) async throws -> BoardItem {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate<BoardItemEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardItemError.notFound
    }

    // Snap to 44×44 grid by rounding to nearest multiple of 44
    let snappedPosition = CGPoint(
      x: round(position.x / 44) * 44,
      y: round(position.y / 44) * 44
    )

    entity.positionX = snappedPosition.x
    entity.positionY = snappedPosition.y
    try modelContext.save()

    return BoardItem(from: entity)
  }

  /// Updates an item's size
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - size: The new size (minimum 2×2 grid units)
  /// - Returns: The updated board item
  /// - Throws: BoardItemError if update fails or item not found
  func updateItemSize(id: UUID, size: CGSize) async throws -> BoardItem {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate<BoardItemEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardItemError.notFound
    }

    // Enforce minimum size of 2×2 grid units (88×88 points)
    let validatedSize = CGSize(
      width: max(88, size.width),
      height: max(88, size.height)
    )

    entity.width = validatedSize.width
    entity.height = validatedSize.height
    try modelContext.save()

    return BoardItem(from: entity)
  }

  /// Deletes an item by its ID
  /// - Parameter id: The ID of the item to delete
  /// - Throws: BoardItemError if deletion fails or item not found
  func deleteItem(id: UUID) async throws {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate<BoardItemEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardItemError.notFound
    }

    modelContext.delete(entity)
    try modelContext.save()
  }

  /// Updates an item's reference to a show object
  /// - Parameters:
  ///   - id: The ID of the item to update
  ///   - referenceID: The ID of the new show object to reference
  /// - Returns: The updated board item
  /// - Throws: BoardItemError if update fails or item/object not found
  func updateItemReference(id: UUID, referenceID: UUID) async throws -> BoardItem {
    let itemDescriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate<BoardItemEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(itemDescriptor).first else {
      throw BoardItemError.notFound
    }

    let objectDescriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == referenceID }
    )

    guard let showObject = try modelContext.fetch(objectDescriptor).first else {
      throw BoardItemError.showObjectNotFound
    }

    entity.referenceID = referenceID
    entity.showObject = showObject
    try modelContext.save()

    return BoardItem(from: entity)
  }
}
