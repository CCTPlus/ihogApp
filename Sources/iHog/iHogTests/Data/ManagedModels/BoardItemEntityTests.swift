//
//  BoardItemEntityTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import SwiftData
import Testing

@testable import iHog

/// Tests for BoardItemEntity to ensure proper initialization and relationship management
@Suite("Board Item Entity Tests")
final class BoardItemEntityTests {
  private var modelContainer: ModelContainer!
  private var modelContext: ModelContext!

  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    modelContainer = try ModelContainer(
      for: BoardItemEntity.self,
      BoardEntity.self,
      ShowObjectEntity.self,
      configurations: config
    )
    modelContext = ModelContext(modelContainer)
  }

  deinit {
    modelContext = nil
    modelContainer = nil
  }

  /// Tests initialization with all properties set
  /// Verifies that all properties are correctly set and preserved
  @Test("BoardItemEntity initialization with all properties")
  func testInitWithAllProperties() throws {
    let entity = BoardItemEntity(
      id: UUID(),
      boardID: UUID(),
      itemType: ShowObjectType.group.rawValue,
      referenceID: UUID(),
      positionX: 100,
      positionY: 200,
      width: 88,
      height: 88
    )

    #expect(entity.id != nil)
    #expect(entity.boardID != nil)
    #expect(entity.itemType == ShowObjectType.group.rawValue)
    #expect(entity.referenceID != nil)
    #expect(entity.positionX == 100)
    #expect(entity.positionY == 200)
    #expect(entity.width == 88)
    #expect(entity.height == 88)
  }

  /// Tests bidirectional relationship with BoardEntity
  /// Verifies that when an item is added to a board, both sides of the relationship are updated
  @Test("BoardItemEntity board relationship")
  func testBoardRelationship() throws {
    let board = BoardEntity()
    let item = BoardItemEntity()

    modelContext.insert(board)
    modelContext.insert(item)

    // Test setting board on item
    item.board = board
    try modelContext.save()

    #expect(item.board == board)
    #expect(board.items?.contains(item) == true)

    // Test removing board from item
    item.board = nil
    try modelContext.save()

    #expect(item.board == nil)
    #expect(board.items?.contains(item) == false)
  }

  /// Tests bidirectional relationship with ShowObjectEntity
  /// Verifies that when an item references a show object, both sides of the one-to-one relationship are updated
  @Test("BoardItemEntity showObject relationship")
  func testShowObjectRelationship() throws {
    let showObject = ShowObjectEntity()
    let item = BoardItemEntity()

    modelContext.insert(showObject)
    modelContext.insert(item)

    // Test setting show object on item
    item.showObject = showObject
    try modelContext.save()

    #expect(item.showObject == showObject)
    #expect(showObject.boardItem == item)

    // Test removing show object from item
    item.showObject = nil
    try modelContext.save()

    #expect(item.showObject == nil)
    #expect(showObject.boardItem == nil)

    // Test setting a new item on the same show object
    let newItem = BoardItemEntity()
    modelContext.insert(newItem)
    showObject.boardItem = newItem
    try modelContext.save()

    #expect(newItem.showObject == showObject)
    #expect(showObject.boardItem == newItem)
  }

  /// Tests cascade deletion from board
  /// Verifies that items are deleted when their parent board is deleted
  @Test("BoardItemEntity cascade deletion")
  func testCascadeDeletion() throws {
    let board = BoardEntity()
    let item = BoardItemEntity()

    modelContext.insert(board)
    modelContext.insert(item)

    // Add item to board
    item.board = board
    try modelContext.save()

    #expect(item.board == board)
    #expect(board.items?.contains(item) == true)

    // Delete board
    modelContext.delete(board)
    try modelContext.save()

    // Verify item is deleted
    let fetchDescriptor = FetchDescriptor<BoardItemEntity>()
    let remainingItems = try modelContext.fetch(fetchDescriptor)
    #expect(remainingItems.isEmpty)
  }
}
