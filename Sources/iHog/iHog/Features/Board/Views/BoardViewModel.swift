import Foundation
import Observation
import SwiftData
import SwiftUI

/// Coordinates the board's state, item placement, and user interactions.
/// Handles persistence, undo/redo, and gesture responses.
@Observable
class BoardViewModel {
  // MARK: - Dependencies

  /// Handles board-level persistence and state restoration
  let repository: BoardRepository

  /// Manages CRUD operations for items on the board
  let itemRepository: BoardItemRepository

  /// Tracks and manages undo/redo operations for item movements and resizes
  let undoManager: UndoManager?

  // MARK: - State

  /// Tracks the current viewport state (zoom, offset) and edit mode
  var boardState: BoardState

  /// The underlying board model containing persistent state
  var board: Board

  /// Currently placed items on the board, maintained in sync with SwiftData
  var items: [BoardItem]

  /// Controls visibility of the object selection menu during placement
  var showingObjectSelection = false

  /// The current drag state for placement
  var placementDragState: PlacementDragState = .inactive

  /// Tracks if we're currently in placement mode
  var isPlacingItem = false

  /// The current placement rectangle being created
  var currentPlacementRect: CGRect?

  // MARK: - Computed Properties

  /// Current viewport offset, derived from boardState for consistency
  var totalOffset: CGPoint {
    boardState.contentOffset
  }

  /// Current zoom scale, converted from boardState's zoomLevel
  var totalScale: CGFloat {
    CGFloat(boardState.zoomLevel)
  }

  // MARK: - Initialization

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

    // Restore saved viewport state on initialization
    restore()

    // Only fetch items if none provided, to support both new boards and restored state
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

  // MARK: - Board State Management

  /// Updates zoom level and triggers viewport recalculation
  func updateZoom(to zoomLevel: Double) {
    boardState.zoomLevel = zoomLevel
  }

  /// Updates viewport offset and triggers view recalculation
  func updateOffset(to offset: CGPoint) {
    boardState.contentOffset = offset
  }

  /// Toggles between edit and play modes, clearing undo stack on exit
  func toggleEditMode() {
    boardState.isEditMode.toggle()
    undoManager?.removeAllActions()
  }

  /// Persists current viewport state to SwiftData
  func save() async throws {
    board = try await repository.updateBoardPositionAndZoom(
      boardID: board.id,
      lastPanOffset: boardState.contentOffset,
      lastZoomScale: boardState.zoomLevel
    )
  }

  /// Restores viewport state from persistent storage
  func restore() {
    boardState.zoomLevel = board.lastZoomScale
    boardState.contentOffset = board.lastPanOffset
  }

  // MARK: - Item Management

  /// Updates item position and registers undo operation
  func moveItem(_ item: BoardItem, to position: CGPoint) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].position = position
    }
  }

  /// Updates item size and registers undo operation
  func resizeItem(_ item: BoardItem, to size: CGSize) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].size = size
    }
  }

  /// Checks if a rectangle would overlap with any existing board items.
  ///
  /// When moving or resizing an existing item, we need to exclude that item from the overlap check.
  /// For example, if we're moving Item A, we want to check if it overlaps with Item B, but not with itself.
  ///
  /// - Parameters:
  ///   - rect: The rectangle to check for overlaps
  ///   - excludingItemID: The ID of an item to exclude from the check. Use this when moving or resizing an existing item
  ///                     to prevent checking for overlap with itself. Set to nil when placing a new item.
  /// - Returns: true if the rectangle would overlap with any existing items, false otherwise
  func wouldOverlap(_ rect: CGRect, excludingItemID: UUID? = nil) -> Bool {
    let itemsToCheck = excludingItemID.map { id in items.filter { $0.id != id } } ?? items
    return itemsToCheck.contains { item in
      let itemRect = CGRect(
        x: item.position.x - item.size.width / 2,
        y: item.position.y - item.size.height / 2,
        width: item.size.width,
        height: item.size.height
      )
      // Use exact intersection check without any padding
      return itemRect.intersects(rect)
    }
  }

  /// Registers a move operation with the undo manager for later reversal
  func registerMoveUndo(for item: BoardItem) {
    guard let undoManager = undoManager else { return }
    let oldPosition = item.position
    undoManager.registerUndo(withTarget: self) { target in
      target.moveItem(item, to: oldPosition)
      target.registerMoveUndo(for: item)
    }
  }

  /// Registers a resize operation with the undo manager for later reversal
  func registerResizeUndo(for item: BoardItem) {
    guard let undoManager = undoManager else { return }
    let oldSize = item.size
    undoManager.registerUndo(withTarget: self) { target in
      target.resizeItem(item, to: oldSize)
      target.registerResizeUndo(for: item)
    }
  }

  /// Prepares to change an item's type, will show object selection menu
  func reassignItem(_ item: BoardItem) {
    // TODO: Implement reassign item
    // This will need to show the object selection menu
  }

  /// Removes an item from both the board and persistent storage
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

  /// Stores placement position and shows object selection menu
  func prepareToAddItem(at rect: CGRect) {
    currentPlacementRect = rect
    showingObjectSelection = true
  }

  /// Creates and adds a new item after object type selection
  func handleObjectSelection(_ object: ShowObject) {
    guard let rect = currentPlacementRect else { return }

    let item = BoardItem(
      id: UUID(),
      boardID: board.id,
      showObjectID: object.id,
      position: rect.center,
      size: CGSize(width: rect.width, height: rect.height)
    )

    Task {
      do {
        let newItem = try await itemRepository.createItem(item, boardID: board.id)
        await MainActor.run {
          items.append(newItem)
          currentPlacementRect = nil
          showingObjectSelection = false
          isPlacingItem = false
          placementDragState = .inactive
        }
      } catch {
        HogLogger.log(category: .board).error("Error adding item: \(error)")
      }
    }
  }

  /// Persists a new item and updates local state
  func addItem(_ item: BoardItem) {
    Task {
      do {
        let newItem = try await itemRepository.createItem(item, boardID: board.id)
        await MainActor.run {
          items.append(newItem)
        }
      } catch {
        HogLogger.log(category: .board).error("Error adding item: \(error)")
      }
    }
  }

  // MARK: - Gesture Handling

  /// Updates viewport offset based on pan gesture translation
  func handlePanGesture(_ value: DragGesture.Value) {
    // Only handle pan if not in placement mode
    guard !isPlacingItem else { return }

    let newOffset = CGPoint(
      x: boardState.contentOffset.x + value.translation.width,
      y: boardState.contentOffset.y + value.translation.height
    )
    updateOffset(to: newOffset)
  }

  /// Updates zoom level based on magnification gesture
  func handleZoomGesture(_ value: CGFloat) {
    // Only handle zoom if not in placement mode
    guard !isPlacingItem else { return }

    let newZoom = boardState.zoomLevel * Double(value)
    updateZoom(to: newZoom)
  }

  // MARK: - Placement Handling

  /// Updates the placement drag state
  func updatePlacementDragState(_ state: PlacementDragState) {
    placementDragState = state
  }

  /// Starts a new placement operation
  func startPlacement() {
    isPlacingItem = true
    placementDragState = .active
  }

  /// Ends the current placement operation
  func endPlacement() {
    isPlacingItem = false
    placementDragState = .inactive
  }
}

/// The possible states of a placement drag operation
enum PlacementDragState {
  case inactive
  case active
  case valid
  case invalid
}
