//
//  BoardSwiftDataRepositoryTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import SwiftData
import Testing

@testable import iHog

/// Tests for BoardSwiftDataRepository implementation
/// Verifies SwiftData-specific behavior and persistence
@Suite("Board SwiftData Repository Tests")
@MainActor
final class BoardSwiftDataRepositoryTests {
  private var modelContainer: ModelContainer!
  private var repository: BoardSwiftDataRepository!

  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    modelContainer = try ModelContainer(for: BoardEntity.self, configurations: config)
    repository = BoardSwiftDataRepository(modelContainer: modelContainer)
  }

  deinit {
    modelContainer = nil
    repository = nil
  }

  /// Tests that a new board can be created and persisted
  /// Verifies that the board is stored in SwiftData and can be retrieved
  @Test("Create board")
  func testCreateBoard() async throws {
    let board = try await repository.createBoard(name: "Test Board")

    // Verify the board was created
    #expect(board.name == "Test Board")

    // Verify the board was persisted
    let boardID = board.id
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.count == 1)
    #expect(entities[0].name == "Test Board")
  }

  /// Tests that boards can be retrieved for a show and are properly sorted
  /// Verifies sorting by dateLastModified in descending order
  @Test("Get boards for show")
  func testGetBoards() async throws {
    let showID = UUID()

    // Create multiple boards with different modification dates
    let board1 = try await repository.createBoard(name: "Board 1")
    let board2 = try await repository.createBoard(name: "Board 2")

    // Set showID for both boards
    let descriptor = FetchDescriptor<BoardEntity>()
    let entities = try modelContainer.mainContext.fetch(descriptor)
    for entity in entities {
      entity.showID = showID
    }
    try modelContainer.mainContext.save()

    let boards = try await repository.getBoards(for: showID)

    #expect(boards.count == 2)
    #expect(boards[0].id == board2.id)  // Newest first
    #expect(boards[1].id == board1.id)
  }

  /// Tests that a board can be deleted and is removed from SwiftData
  /// Verifies that the board is no longer accessible after deletion
  @Test("Delete board")
  func testDeleteBoard() async throws {
    let board = try await repository.createBoard(name: "Test Board")

    try await repository.deleteBoard(id: board.id)
    let boardID = board.id
    // Verify the board was deleted
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.isEmpty)
  }

  /// Tests that a board's name can be updated and changes are persisted
  /// Verifies that the update is stored in SwiftData
  @Test("Update board name")
  func testUpdateBoardName() async throws {
    let board = try await repository.createBoard(name: "Original Name")
    let originalDate = board.dateLastModified

    let updatedBoard = try await repository.updateBoardName(id: board.id, name: "New Name")

    #expect(updatedBoard.name == "New Name")
    #expect(updatedBoard.dateLastModified > originalDate)

    let boardID = board.id
    // Verify the update was persisted
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.count == 1)
    #expect(entities[0].name == "New Name")
  }

  /// Tests that a board's pan offset can be updated and changes are persisted
  /// Verifies that the update is stored in SwiftData
  @Test("Update board pan offset")
  func testUpdateBoardPanOffset() async throws {
    let board = try await repository.createBoard(name: "Test Board")
    let originalDate = board.dateLastModified

    let newOffset = CGPoint(x: 100, y: 200)
    let updatedBoard = try await repository.updateBoardPanOffset(id: board.id, offset: newOffset)

    #expect(updatedBoard.lastPanOffset == newOffset)
    #expect(updatedBoard.dateLastModified > originalDate)
    let boardID = board.id
    // Verify the update was persisted
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.count == 1)
    #expect(entities[0].lastPanOffsetX == 100)
    #expect(entities[0].lastPanOffsetY == 200)
  }

  /// Tests that a board's zoom scale can be updated and changes are persisted
  /// Verifies that the update is stored in SwiftData
  @Test("Update board zoom scale")
  func testUpdateBoardZoomScale() async throws {
    let board = try await repository.createBoard(name: "Test Board")
    let originalDate = board.dateLastModified

    let newScale: CGFloat = 2.0
    let updatedBoard = try await repository.updateBoardZoomScale(id: board.id, scale: newScale)

    #expect(updatedBoard.lastZoomScale == newScale)
    #expect(updatedBoard.dateLastModified > originalDate)

    let boardID = board.id
    // Verify the update was persisted
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == boardID }
    )
    let entities = try modelContainer.mainContext.fetch(descriptor)
    #expect(entities.count == 1)
    #expect(entities[0].lastZoomScale == 2.0)
  }

  /// Tests that updating a non-existent board's name throws notFound error
  @Test("Update non-existent board name throws error")
  func testUpdateNonExistentBoardName() async throws {
    let invalidID = UUID()
    await #expect(throws: BoardError.notFound) {
      try await self.repository.updateBoardName(id: invalidID, name: "New Name")
    }
  }

  /// Tests that updating a non-existent board's pan offset throws notFound error
  @Test("Update non-existent board pan offset throws error")
  func testUpdateNonExistentBoardPanOffset() async throws {
    let invalidID = UUID()
    await #expect(throws: BoardError.notFound) {
      try await self.repository.updateBoardPanOffset(id: invalidID, offset: .zero)
    }
  }

  /// Tests that updating a non-existent board's zoom scale throws notFound error
  @Test("Update non-existent board zoom scale throws error")
  func testUpdateNonExistentBoardZoomScale() async throws {
    let invalidID = UUID()
    await #expect(throws: BoardError.notFound) {
      try await self.repository.updateBoardZoomScale(id: invalidID, scale: 1.0)
    }
  }

  /// Tests that deleting a non-existent board throws notFound error
  @Test("Delete non-existent board throws error")
  func testDeleteNonExistentBoard() async throws {
    let invalidID = UUID()
    await #expect(throws: BoardError.notFound) {
      try await self.repository.deleteBoard(id: invalidID)
    }
  }
}
