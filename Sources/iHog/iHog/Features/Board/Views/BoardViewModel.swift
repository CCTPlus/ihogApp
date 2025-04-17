import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class BoardViewModel {
  var boardState: BoardState
  let undoManager: UndoManager?
  let repository: BoardRepository
  let itemRepository: BoardItemRepository
  var board: Board
  var items: [BoardItem]

  init(
    board: Board,
    boardState: BoardState = .init(),
    repository: BoardRepository,
    itemRepository: BoardItemRepository,
    items: [BoardItem] = []
  ) {
    self.board = board
    self.boardState = boardState
    self.undoManager = UndoManager()
    self.repository = repository
    self.itemRepository = itemRepository
    self.items = items

    // Restore saved state on init
    restore()

    // Fetch items if none provided
    if items.isEmpty {
      Task {
        do {
          let foundItems = try await itemRepository.fetchItems(for: board.id)
          await MainActor.run {
            self.items = foundItems
          }
        } catch {
          print("Error fetching items: \(error)")
        }
      }
    }
  }

  func updateZoom(to zoomLevel: Double) {
    boardState.zoomLevel = zoomLevel
  }

  func updateOffset(to offset: CGPoint) {
    boardState.contentOffset = offset
  }

  func toggleEditMode() {
    boardState.isEditMode.toggle()
    undoManager?.removeAllActions()  // Clear undo stack on mode exit
  }

  func save() async throws {
    // Update board with current state
    board = try await repository.updateBoardPositionAndZoom(
      boardID: board.id,
      lastPanOffset: boardState.contentOffset,
      lastZoomScale: boardState.zoomLevel
    )
  }

  func restore() {
    // Restore saved state from board
    if let savedZoom = board.lastZoomScale {
      boardState.zoomLevel = savedZoom
    }
    boardState.contentOffset = board.lastPanOffset
  }
}
