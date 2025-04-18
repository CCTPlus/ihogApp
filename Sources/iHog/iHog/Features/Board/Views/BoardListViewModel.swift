import Foundation
import Observation
import SwiftData

/// Manages the state and operations for displaying and managing a list of boards within a show.
/// Handles board loading, selection, renaming, and deletion operations.
@Observable
class BoardListViewModel {
  /// Handles CRUD operations for board entities
  let repository: BoardRepository

  /// Manages board items and their relationships
  let itemRepository: BoardItemRepository

  /// Manages show objects and their relationships
  let showObjectRepository: ShowObjectRepository

  /// ID of the show containing the boards
  let showID: UUID

  /// Currently loaded boards from the repository
  var boards: [Board] = []

  /// Board selected for full screen viewing
  var selectedBoard: Board?

  /// Board being renamed
  var boardToRename: Board?

  /// Board pending deletion
  var boardToDelete: Board?

  /// New name for the board being renamed
  var newBoardName: String = ""

  /// Controls rename alert presentation
  var isRenameAlertPresented: Bool = false

  /// Controls delete confirmation alert presentation
  var isDeleteAlertPresented: Bool = false

  init(
    showID: UUID,
    repository: BoardRepository,
    itemRepository: BoardItemRepository,
    showObjectRepository: ShowObjectRepository
  ) {
    self.showID = showID
    self.repository = repository
    self.itemRepository = itemRepository
    self.showObjectRepository = showObjectRepository
  }

  /// Loads and updates the boards list
  func loadBoards() async {
    do {
      boards = try await repository.getAllBoards(for: showID)
    } catch {
      HogLogger.log(category: .board).error("Error loading boards: \(error)")
    }
  }

  /// Sets up the rename alert state
  /// - Parameter board: Board to rename
  func prepareToRename(_ board: Board) {
    boardToRename = board
    newBoardName = board.name
    isRenameAlertPresented = true
  }

  /// Resets rename operation state
  func cancelRename() {
    boardToRename = nil
    newBoardName = ""
    isRenameAlertPresented = false
  }

  /// Updates board name and refreshes list
  func renameBoard() async {
    guard let board = boardToRename else { return }
    do {
      _ = try await repository.updateBoardName(newBoardName, for: board.id)
      await loadBoards()
      cancelRename()
    } catch {
      HogLogger.log(category: .board).error("Error renaming board: \(error)")
    }
  }

  /// Sets up delete confirmation state
  /// - Parameter board: Board to delete
  func prepareToDelete(_ board: Board) {
    boardToDelete = board
    isDeleteAlertPresented = true
  }

  /// Resets delete operation state
  func cancelDelete() {
    boardToDelete = nil
    isDeleteAlertPresented = false
  }

  /// Removes board and refreshes list
  func deleteBoard() async {
    guard let board = boardToDelete else { return }
    do {
      try await repository.deleteBoard(by: board.id)
      await loadBoards()
      cancelDelete()
    } catch {
      HogLogger.log(category: .board).error("Error deleting board: \(error)")
    }
  }
}
