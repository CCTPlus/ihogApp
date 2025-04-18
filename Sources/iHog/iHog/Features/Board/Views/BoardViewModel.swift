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

  /// The current total offset
  var totalOffset: CGPoint {
    boardState.contentOffset
  }

  /// The current total scale
  var totalScale: CGFloat {
    CGFloat(boardState.zoomLevel)
  }

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
          HogLogger.log(category: .board).error("Error fetching items: \(error)")
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
    boardState.zoomLevel = board.lastZoomScale
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
        await MainActor.run {
          items.removeAll { $0.id == item.id }
        }
      } catch {
        HogLogger.log(category: .board).error("Error removing item: \(error)")
      }
    }
  }

  // MARK: - Gesture Handling

  func handlePanGesture(_ value: DragGesture.Value) {
    let newOffset = CGPoint(
      x: boardState.contentOffset.x + value.translation.width,
      y: boardState.contentOffset.y + value.translation.height
    )
    updateOffset(to: newOffset)
  }

  func handleZoomGesture(_ value: CGFloat) {
    let newZoom = boardState.zoomLevel * Double(value)
    updateZoom(to: newZoom)
  }
}
