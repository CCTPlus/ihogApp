//
//  BoardItemMockRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation

/// Mock repository for board items used in previews and testing
/// Implements BoardItemRepository protocol with in-memory storage
final class BoardItemMockRepository: BoardItemRepository {
  private var items: [BoardItem]

  /// Creates a mock repository with the given items
  /// - Parameter items: Initial items to populate the repository
  init(items: [BoardItem] = []) {
    self.items = items
  }

  func placeItem(
    boardID: UUID,
    itemType: ShowObjectType,
    referenceID: UUID,
    position: CGPoint,
    size: CGSize
  ) async throws -> BoardItem {
    // Enforce minimum size
    let enforcedSize = CGSize(
      width: max(size.width, 88),
      height: max(size.height, 88)
    )

    let item = BoardItem(
      id: UUID(),
      boardID: boardID,
      itemType: itemType,
      referenceID: referenceID,
      position: position,
      size: enforcedSize
    )

    items.append(item)
    return item
  }

  func getItems(for boardID: UUID) async throws -> [BoardItem] {
    // Filter items for this board and sort by Y ascending, then X ascending
    return
      items
      .filter { $0.boardID == boardID }
      .sorted { first, second in
        if first.position.y == second.position.y {
          return first.position.x < second.position.x
        }
        return first.position.y < second.position.y
      }
  }

  func updateItemPosition(id: UUID, position: CGPoint) async throws -> BoardItem {
    guard let index = items.firstIndex(where: { $0.id == id }) else {
      throw BoardItemError.notFound
    }

    // Snap to grid
    let snappedPosition = CGPoint(
      x: round(position.x / 44) * 44,
      y: round(position.y / 44) * 44
    )

    var item = items[index]
    item.position = snappedPosition
    items[index] = item
    return item
  }

  func updateItemSize(id: UUID, size: CGSize) async throws -> BoardItem {
    guard let index = items.firstIndex(where: { $0.id == id }) else {
      throw BoardItemError.notFound
    }

    // Enforce minimum size
    let enforcedSize = CGSize(
      width: max(size.width, 88),
      height: max(size.height, 88)
    )

    var item = items[index]
    item.size = enforcedSize
    items[index] = item
    return item
  }

  func deleteItem(id: UUID) async throws {
    guard let index = items.firstIndex(where: { $0.id == id }) else {
      throw BoardItemError.notFound
    }

    items.remove(at: index)
  }

  func updateItemReference(id: UUID, referenceID: UUID) async throws -> BoardItem {
    guard let index = items.firstIndex(where: { $0.id == id }) else {
      throw BoardItemError.notFound
    }

    var item = items[index]
    item.referenceID = referenceID
    items[index] = item
    return item
  }
}
