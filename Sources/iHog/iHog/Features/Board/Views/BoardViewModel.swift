import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class BoardViewModel {
  var boardState: BoardState
  let undoManager: UndoManager?
  let repository: BoardRepository
  var board: Board

  init(
    board: Board,
    boardState: BoardState = .init(),
    repository: BoardRepository
  ) {
    self.board = board
    self.boardState = boardState
    self.undoManager = UndoManager()
    self.repository = repository

    // Restore saved state on init
    restore()
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
