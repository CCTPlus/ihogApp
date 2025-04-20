//
//  BoardListViewModelTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import Testing

@testable import iHog

/// Tests for the BoardListViewModel, verifying its ability to manage boards within a show.
/// Each test focuses on a single behavior to ensure clear test isolation and maintainability.
@Suite("BoardListViewModel Tests")
struct BoardListViewModelTests {
  /// ID of the show used for testing board management
  private let showID = UUID()

  /// Verifies that a new view model initializes with empty state.
  /// This ensures the view model starts in a clean state before any operations.
  @Test("Initialization loads empty state")
  func initialization() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)

    #expect(viewModel.selectedBoard == nil)
    #expect(viewModel.boards.isEmpty)
  }

  /// Verifies that creating a new board:
  /// 1. Adds it to the boards list
  /// 2. Sets it as the selected board
  /// 3. Uses the correct default name and show ID
  @Test("Create new board adds to list and selects it")
  func createNewBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()

    #expect(viewModel.selectedBoard != nil)
    #expect(viewModel.boards.count == 1)
    #expect(viewModel.boards[0].name == "New Board")
    #expect(viewModel.boards[0].showID == showID)
  }

  /// Verifies that deleting the selected board:
  /// 1. Removes it from the boards list
  /// 2. Clears the selected board
  /// This ensures proper state cleanup when removing the active board.
  @Test("Delete board removes from list and deselects if selected")
  func deleteBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let boardID = viewModel.boards[0].id
    viewModel.selectBoard(viewModel.boards[0])

    try await viewModel.deleteBoard(boardID)

    #expect(viewModel.selectedBoard == nil)
    #expect(viewModel.boards.isEmpty)
  }

  /// Verifies that deleting a board that is not selected:
  /// 1. Removes it from the boards list
  /// 2. Preserves the selected board
  /// This ensures board deletion doesn't affect unrelated state.
  @Test("Delete different board keeps selection")
  func deleteDifferentBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let board1 = viewModel.boards[0]
    try await viewModel.createNewBoard()
    let board2 = viewModel.boards[0]

    viewModel.selectBoard(board1)
    try await viewModel.deleteBoard(board2.id)

    #expect(viewModel.boards.count == 1)
    #expect(viewModel.boards[0].id == board1.id)
    #expect(viewModel.selectedBoard?.id == board1.id)
  }

  /// Verifies that updating a board's name:
  /// 1. Updates the name in the boards list
  /// 2. Updates the name in the selected board if it's the same board
  /// This ensures name changes are properly synchronized across all references.
  @Test("Update board name updates both list and selection")
  func updateBoardName() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let boardID = viewModel.boards[0].id
    viewModel.selectBoard(viewModel.boards[0])

    try await viewModel.updateBoardName(boardID, to: "Updated Name")

    #expect(viewModel.boards[0].name == "Updated Name")
    #expect(viewModel.selectedBoard?.name == "Updated Name")
  }

  /// Verifies that selecting a board:
  /// 1. Updates the selected board reference
  /// This ensures the view model can track the active board.
  @Test("Select board updates selection")
  func selectBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let board = viewModel.boards[0]

    viewModel.selectBoard(board)

    #expect(viewModel.selectedBoard?.id == board.id)
  }

  /// Verifies that deselecting a board clears the selectedBoard property.
  /// This test ensures that the view model correctly handles board dismissal.
  @Test
  func deselectBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()

    let board = viewModel.boards[0]
    viewModel.selectBoard(board)
    viewModel.deselectBoard()

    #expect(viewModel.selectedBoard == nil)
  }

  /// Verifies that loading boards:
  /// 1. Loads all boards for the show
  /// 2. Sorts them by last modified date in descending order
  /// This ensures proper board loading and sorting behavior.
  @Test("Load boards loads and sorts by date")
  func loadBoards() async throws {
    let mockRepository = BoardMockRepository()
    let board1 = try await mockRepository.createBoard(name: "Board 1", showID: showID)
    let board2 = try await mockRepository.createBoard(name: "Board 2", showID: showID)

    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    #expect(viewModel.boards.count == 2)
    #expect(viewModel.boards[0].id == board2.id)  // Newest first
    #expect(viewModel.boards[1].id == board1.id)
  }

  /// Verifies that deleting a non-existent board throws BoardError.notFound.
  /// This ensures proper error handling for invalid board IDs.
  @Test("Delete non-existent board throws not found")
  func deleteNonExistentBoard() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let originalBoardID = viewModel.boards[0].id

    await #expect(throws: BoardError.notFound) {
      try await viewModel.deleteBoard(UUID())
    }

    #expect(viewModel.boards.count == 1)
    #expect(viewModel.boards[0].id == originalBoardID)
  }

  /// Verifies that updating a non-existent board's name throws BoardError.notFound.
  /// This ensures proper error handling for invalid board IDs.
  @Test("Update non-existent board name throws not found")
  func updateNonExistentBoardName() async throws {
    let mockRepository = BoardMockRepository()
    let viewModel = BoardListViewModel(showID: showID, boardRepository: mockRepository)
    await viewModel.loadBoards()

    try await viewModel.createNewBoard()
    let originalBoardID = viewModel.boards[0].id
    let originalName = viewModel.boards[0].name

    await #expect(throws: BoardError.notFound) {
      try await viewModel.updateBoardName(UUID(), to: "New Name")
    }

    #expect(viewModel.boards.count == 1)
    #expect(viewModel.boards[0].id == originalBoardID)
    #expect(viewModel.boards[0].name == originalName)
  }
}
