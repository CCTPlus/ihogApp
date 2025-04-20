//
//  BoardListViewModel.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import Observation

/// Manages the lifecycle and state of boards within a show, including creation, deletion, and selection.
/// Uses the repository pattern to persist changes and maintain consistency across the app.
@Observable
final class BoardListViewModel {
  // MARK: - Properties

  /// Currently selected board, if any
  var selectedBoard: Board?

  /// List of boards for the current show, sorted by last modified date
  private(set) var boards: [Board] = []

  /// Repository for board operations
  private let boardRepository: BoardRepository

  /// ID of the show these boards belong to
  private let showID: UUID

  // MARK: - Initialization

  /// Creates a new BoardListViewModel for managing boards in a show
  /// - Parameters:
  ///   - showID: The ID of the show these boards belong to
  ///   - boardRepository: Repository for board operations
  init(showID: UUID, boardRepository: BoardRepository) {
    self.showID = showID
    self.boardRepository = boardRepository
  }

  // MARK: - Public Methods

  /// Loads all boards for the current show, sorted by last modified date.
  /// This should be called after initialization to populate the boards list.
  func loadBoards() async {
    do {
      let loadedBoards = try await boardRepository.getBoards(for: showID)
      await MainActor.run {
        self.boards = loadedBoards
      }
    } catch {
      Analytics.shared.logError(with: error, for: .board, level: .critical)
    }
  }

  /// Creates a new board and sets it as the selected board.
  /// The new board is inserted at the start of the list to maintain chronological order.
  func createNewBoard() async throws {
    let newBoard = try await boardRepository.createBoard(
      name: "New Board",
      showID: showID
    )
    await MainActor.run {
      boards.insert(newBoard, at: 0)
      selectedBoard = newBoard
    }
  }

  /// Permanently removes a board and updates the selected board if necessary.
  /// This operation cannot be undone and will cascade delete all board items.
  func deleteBoard(_ boardID: UUID) async throws {
    await MainActor.run {
      if selectedBoard?.id == boardID {
        selectedBoard = nil
      }
      boards.removeAll { $0.id == boardID }
    }
    try await boardRepository.deleteBoard(id: boardID)
  }

  /// Updates a board's name and ensures both the list and selected board stay in sync.
  /// The update is persisted through the repository layer.
  func updateBoardName(_ boardID: UUID, to newName: String) async throws {
    let updatedBoard = try await boardRepository.updateBoardName(id: boardID, name: newName)
    await MainActor.run {
      if let index = boards.firstIndex(where: { $0.id == boardID }) {
        boards[index] = updatedBoard
      }
      if selectedBoard?.id == boardID {
        selectedBoard = updatedBoard
      }
    }
  }

  /// Presents a rename dialog for the specified board.
  /// - Parameter boardID: The ID of the board to rename
  func renameBoard(_ boardID: UUID) async {
    // TODO: Implement rename dialog
    // This will be implemented when we add the rename UI
  }

  /// Changes the currently selected board without persisting the change.
  /// Used for UI state management and board switching.
  func selectBoard(_ board: Board) {
    selectedBoard = board
  }

  /// Deselects the currently selected board.
  /// Used when dismissing the board view.
  func deselectBoard() {
    selectedBoard = nil
  }
}

// MARK: - Preview Support
extension BoardListViewModel {
  /// Preview view model for SwiftUI previews
  static let preview = BoardListViewModel(
    showID: UUID(),
    boardRepository: BoardMockRepository()
  )
}
