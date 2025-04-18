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

  func moveItem(_ item: BoardItem, to position: CGPoint) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].position = position
    }
  }

  func resizeItem(_ item: BoardItem, to size: CGSize) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].size = size
    }
  }

  func wouldOverlap(item: BoardItem, at position: CGPoint) -> Bool {
    let otherItems = items.filter { $0.id != item.id }
    return otherItems.contains { otherItem in
      let itemRect = CGRect(
        x: position.x,
        y: position.y,
        width: item.size.width,
        height: item.size.height
      )
      let otherRect = CGRect(
        x: otherItem.position.x,
        y: otherItem.position.y,
        width: otherItem.size.width,
        height: otherItem.size.height
      )
      return itemRect.intersects(otherRect)
    }
  }

  func wouldOverlap(item: BoardItem, with size: CGSize) -> Bool {
    let otherItems = items.filter { $0.id != item.id }
    return otherItems.contains { otherItem in
      let itemRect = CGRect(
        x: item.position.x,
        y: item.position.y,
        width: size.width,
        height: size.height
      )
      let otherRect = CGRect(
        x: otherItem.position.x,
        y: otherItem.position.y,
        width: otherItem.size.width,
        height: otherItem.size.height
      )
      return itemRect.intersects(otherRect)
    }
  }

  func registerMoveUndo(for item: BoardItem) {
    guard let undoManager = undoManager else { return }
    let oldPosition = item.position
    undoManager.registerUndo(withTarget: self) { target in
      target.moveItem(item, to: oldPosition)
      target.registerMoveUndo(for: item)
    }
  }

  func registerResizeUndo(for item: BoardItem) {
    guard let undoManager = undoManager else { return }
    let oldSize = item.size
    undoManager.registerUndo(withTarget: self) { target in
      target.resizeItem(item, to: oldSize)
      target.registerResizeUndo(for: item)
    }
  }

  func reassignItem(_ item: BoardItem) {
    // TODO: Implement reassign item
    // This will need to show the object selection menu
  }

  func removeItem(_ item: BoardItem) {
    Task {
      do {
        try await itemRepository.deleteItem(by: item.id)
        items.removeAll { $0.id == item.id }
      } catch {
        print("Error removing item: \(error)")
      }
    }
  }
}
