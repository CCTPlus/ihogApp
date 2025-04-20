//
//  BoardItemSwiftDataRepositoryTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import SwiftData
import Testing

@testable import iHog

/// Tests for BoardItemSwiftDataRepository implementation
/// Verifies SwiftData-specific behavior and persistence
@Suite("Board Item SwiftData Repository Tests")
@MainActor
final class BoardItemSwiftDataRepositoryTests {
  private var modelContainer: ModelContainer!
  private var repository: BoardItemSwiftDataRepository!
  private var board: BoardEntity!
  private var showObject: ShowObjectEntity!

  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    modelContainer = try ModelContainer(
      for: BoardItemEntity.self,
      BoardEntity.self,
      ShowObjectEntity.self,
      configurations: config
    )
    repository = BoardItemSwiftDataRepository(modelContainer: modelContainer)

    // Create test board
    board = BoardEntity(id: UUID(), name: "Test Board")
    modelContainer.mainContext.insert(board)

    // Create test show object
    showObject = ShowObjectEntity()
    showObject.id = UUID()
    showObject.objType = ShowObjectType.group.rawValue
    modelContainer.mainContext.insert(showObject)

    try modelContainer.mainContext.save()
  }

  deinit {
    modelContainer = nil
    repository = nil
    board = nil
    showObject = nil
  }

  /// Tests placing a new item on a board
  /// Verifies that the item is created with correct properties and relationships
  @Test("Place item")
  func testPlaceItem() async throws {
    let position = CGPoint(x: 44, y: 88)
    let size = CGSize(width: 88, height: 88)

    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: position,
      size: size
    )

    // Verify item properties
    #expect(item.boardID == board.id)
    #expect(item.itemType == .group)
    #expect(item.referenceID == showObject.id)
    #expect(item.position == position)
    #expect(item.size == size)

    // Fetch updated entities
    let descriptor = FetchDescriptor<BoardItemEntity>()
    let entities = try modelContainer.mainContext.fetch(descriptor)

    // Fetch updated show object to get latest relationship state
    let showObjectID = showObject.id!
    let objectDescriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == showObjectID }
    )
    let updatedShowObject = try modelContainer.mainContext.fetch(objectDescriptor).first

    #expect(entities.count == 1)
    #expect(entities[0].board == board)
    #expect(entities[0].showObject == showObject)
    #expect(updatedShowObject?.boardItem == entities[0])
  }

  /// Tests enforcing minimum size when placing item
  /// Verifies that items cannot be created smaller than 2×2 grid units
  @Test("Place item with minimum size enforcement")
  func testPlaceItemMinimumSize() async throws {
    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: .zero,
      size: CGSize(width: 44, height: 44)  // Too small
    )

    #expect(item.size.width == 88)  // Should be enforced to minimum
    #expect(item.size.height == 88)
  }

  /// Tests getting items for a board with correct sorting
  /// Verifies that items are sorted by Y ascending, then X ascending
  @Test("Get items with sorting")
  func testGetItemsWithSorting() async throws {
    // Create second show object
    let showObject2 = ShowObjectEntity()
    showObject2.id = UUID()
    showObject2.objType = ShowObjectType.group.rawValue
    modelContainer.mainContext.insert(showObject2)
    try modelContainer.mainContext.save()

    // First item with original show object
    _ = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: CGPoint(x: 0, y: -44),
      size: CGSize(width: 88, height: 88)
    )

    // Second item with new show object
    _ = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject2.id!,
      position: CGPoint(x: 44, y: 0),
      size: CGSize(width: 88, height: 88)
    )

    let items = try await repository.getItems(for: board.id!)

    #expect(items.count == 2)
    #expect(items[0].position.y == -44)
    #expect(items[1].position.y == 0)
  }

  /// Tests updating item position with grid snapping
  /// Verifies that positions are snapped to the 44×44 grid
  @Test("Update item position with grid snapping")
  func testUpdateItemPositionWithSnapping() async throws {
    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: .zero,
      size: CGSize(width: 88, height: 88)
    )

    let updatedItem = try await repository.updateItemPosition(
      id: item.id,
      position: CGPoint(x: 50, y: 60)  // Off-grid
    )

    #expect(updatedItem.position.x == 44)  // Should snap to nearest grid point
    #expect(updatedItem.position.y == 44)
  }

  /// Tests updating item size with minimum enforcement
  /// Verifies that items cannot be resized smaller than 2×2 grid units
  @Test("Update item size with minimum enforcement")
  func testUpdateItemSizeWithMinimum() async throws {
    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: .zero,
      size: CGSize(width: 88, height: 88)
    )

    let updatedItem = try await repository.updateItemSize(
      id: item.id,
      size: CGSize(width: 44, height: 44)  // Too small
    )

    #expect(updatedItem.size.width == 88)  // Should be enforced to minimum
    #expect(updatedItem.size.height == 88)
  }

  /// Tests deleting an item
  /// Verifies that the item is removed from SwiftData and the one-to-one relationship is cleared
  @Test("Delete item")
  func testDeleteItem() async throws {
    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: .zero,
      size: CGSize(width: 88, height: 88)
    )

    try await repository.deleteItem(id: item.id)

    let descriptor = FetchDescriptor<BoardItemEntity>()
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.isEmpty)
    #expect(showObject.boardItem == nil)
  }

  /// Tests updating item reference
  /// Verifies that the item's show object reference is updated and the one-to-one relationship is maintained
  @Test("Update item reference")
  func testUpdateItemReference() async throws {
    let item = try await repository.placeItem(
      boardID: board.id!,
      itemType: .group,
      referenceID: showObject.id!,
      position: .zero,
      size: CGSize(width: 88, height: 88)
    )

    // Create new show object to reference
    let newShowObject = ShowObjectEntity()
    newShowObject.id = UUID()
    newShowObject.objType = ShowObjectType.intensity.rawValue
    modelContainer.mainContext.insert(newShowObject)
    try modelContainer.mainContext.save()

    let updatedItem = try await repository.updateItemReference(
      id: item.id,
      referenceID: newShowObject.id!
    )

    #expect(updatedItem.referenceID == newShowObject.id)

    let descriptor = FetchDescriptor<BoardItemEntity>()
    let entity = try modelContainer.mainContext.fetch(descriptor).first
    let updatedShowObjectID = newShowObject.id!
    // Fetch the updated show object to get latest state
    let updatedShowObjectDescriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == updatedShowObjectID }
    )
    let updatedNewShowObject = try modelContainer.mainContext.fetch(updatedShowObjectDescriptor)
      .first

    #expect(entity?.showObject == updatedNewShowObject)
    #expect(updatedNewShowObject?.boardItem == entity)
    #expect(showObject.boardItem == nil)
  }

  /// Tests that placing an item with an invalid board ID throws boardNotFound error
  @Test("Place item with invalid board ID throws error")
  func testPlaceItemWithInvalidBoardID() async throws {
    await #expect(throws: BoardItemError.boardNotFound) {
      try await self.repository.placeItem(
        boardID: UUID(),
        itemType: .group,
        referenceID: self.showObject.id!,
        position: .zero,
        size: CGSize(width: 88, height: 88)
      )
    }
  }

  /// Tests that placing an item with an invalid show object ID throws showObjectNotFound error
  @Test("Place item with invalid show object ID throws error")
  func testPlaceItemWithInvalidShowObjectID() async throws {
    await #expect(throws: BoardItemError.showObjectNotFound) {
      try await self.repository.placeItem(
        boardID: self.board.id!,
        itemType: .group,
        referenceID: UUID(),
        position: .zero,
        size: CGSize(width: 88, height: 88)
      )
    }
  }

  /// Tests that updating position of a non-existent item throws notFound error
  @Test("Update position of non-existent item throws error")
  func testUpdatePositionOfNonExistentItem() async throws {
    await #expect(throws: BoardItemError.notFound) {
      try await self.repository.updateItemPosition(
        id: UUID(),
        position: .zero
      )
    }
  }
}
