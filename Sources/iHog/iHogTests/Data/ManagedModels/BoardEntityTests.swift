//
//  BoardEntityTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation
import SwiftData
import Testing

@testable import iHog

/// Tests for BoardEntity to ensure proper initialization and relationship management
@Suite("Board Entity Tests")
final class BoardEntityTests {
  private var modelContainer: ModelContainer!
  private var modelContext: ModelContext!

  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    modelContainer = try ModelContainer(
      for: BoardEntity.self,
      ShowEntity.self,
      BoardItemEntity.self,
      configurations: config
    )
    modelContext = ModelContext(modelContainer)
  }

  deinit {
    modelContext = nil
    modelContainer = nil
  }

  /// Tests that a new BoardEntity is created with default values
  /// Verifies all optional properties are nil and a new UUID is generated
  @Test("BoardEntity initialization with default values")
  func testDefaultInitialization() throws {
    let entity = BoardEntity()
    modelContext.insert(entity)
    try modelContext.save()

    #expect(entity.id != nil)
    #expect(entity.name == nil)
    #expect(entity.showID == nil)
    #expect(entity.lastPanOffsetX == nil)
    #expect(entity.lastPanOffsetY == nil)
    #expect(entity.lastZoomScale == nil)
    #expect(entity.dateLastModified == nil)
    #expect(entity.items == nil)
    #expect(entity.show == nil)
  }

  /// Tests that BoardEntity can be initialized with custom values
  /// Verifies all properties are correctly set
  @Test("BoardEntity initialization with custom values")
  func testCustomInitialization() throws {
    let id = UUID()
    let showID = UUID()
    let date = Date()

    let entity = BoardEntity(
      id: id,
      name: "Test Board",
      showID: showID,
      lastPanOffsetX: 100.0,
      lastPanOffsetY: 200.0,
      lastZoomScale: 2.0,
      dateLastModified: date
    )

    modelContext.insert(entity)
    try modelContext.save()

    #expect(entity.id == id)
    #expect(entity.name == "Test Board")
    #expect(entity.showID == showID)
    #expect(entity.lastPanOffsetX == 100.0)
    #expect(entity.lastPanOffsetY == 200.0)
    #expect(entity.lastZoomScale == 2.0)
    #expect(entity.dateLastModified == date)
  }

  /// Tests bidirectional relationship with ShowEntity
  /// Verifies that when a board is added to a show, both sides of the relationship are updated
  @Test("BoardEntity show relationship")
  func testShowRelationship() throws {
    let board = BoardEntity()
    let show = ShowEntity(name: "Test Show")

    modelContext.insert(board)
    modelContext.insert(show)

    // Test setting show on board
    board.show = show
    try modelContext.save()

    #expect(board.show == show)
    #expect(show.boards?.contains(board) == true)

    // Test removing show from board
    board.show = nil
    try modelContext.save()

    #expect(board.show == nil)
    #expect(show.boards?.contains(board) == false)

    // Test adding board to show
    show.boards?.append(board)
    try modelContext.save()

    #expect(show.boards?.contains(board) == true)
    #expect(board.show == show)
  }

  /// Tests bidirectional relationship with BoardItemEntity
  /// Verifies that when items are added to a board, both sides of the relationship are updated
  @Test("BoardEntity items relationship")
  func testItemsRelationship() throws {
    let board = BoardEntity()
    let item1 = BoardItemEntity()
    let item2 = BoardItemEntity()

    modelContext.insert(board)
    modelContext.insert(item1)
    modelContext.insert(item2)

    // Test adding items to board
    board.items?.append(contentsOf: [item1, item2])
    try modelContext.save()

    #expect(board.items?.count == 2)
    #expect(board.items?.contains(item1) == true)
    #expect(board.items?.contains(item2) == true)
    #expect(item1.board == board)
    #expect(item2.board == board)

    // Test removing items from board
    board.items?.removeAll { $0 == item1 }
    try modelContext.save()

    #expect(board.items?.count == 1)
    #expect(board.items?.contains(item1) == false)
    #expect(board.items?.contains(item2) == true)
    #expect(item1.board == nil)
    #expect(item2.board == board)
  }

  /// Tests cascade deletion of items
  /// Verifies that all items are deleted when their parent board is deleted
  @Test("BoardEntity cascade deletion")
  func testCascadeDeletion() throws {
    let board = BoardEntity()
    let item1 = BoardItemEntity()
    let item2 = BoardItemEntity()

    modelContext.insert(board)
    modelContext.insert(item1)
    modelContext.insert(item2)

    // Add items to board
    board.items?.append(contentsOf: [item1, item2])
    try modelContext.save()

    #expect(board.items?.count == 2)
    #expect(item1.board == board)
    #expect(item2.board == board)

    // Delete board
    modelContext.delete(board)
    try modelContext.save()

    // Verify items are deleted
    let fetchDescriptor = FetchDescriptor<BoardItemEntity>()
    let remainingItems = try modelContext.fetch(fetchDescriptor)
    #expect(remainingItems.isEmpty)
  }

  /// Tests that dateLastModified is updated when any property changes
  @Test("BoardEntity dateLastModified updates")
  func testDateLastModifiedUpdates() throws {
    let board = BoardEntity()
    modelContext.insert(board)
    try modelContext.save()

    let initialDate = board.dateLastModified

    // Modify a property
    board.name = "New Name"
    try modelContext.save()

    // Verify date changed
    #expect(board.dateLastModified != nil)
    #expect(initialDate == nil || board.dateLastModified != initialDate)

    // Store the new date
    let secondDate = board.dateLastModified

    // Modify another property
    board.lastZoomScale = 2.0
    try modelContext.save()

    // Verify date changed again
    #expect(board.dateLastModified != nil)
    #expect(secondDate == nil || board.dateLastModified != secondDate)
  }
}
