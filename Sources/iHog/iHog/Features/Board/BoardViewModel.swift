//
//  BoardViewModel.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import Observation

/// The mode the board is currently in
enum BoardMode {
  /// Edit mode allows adding, moving, and resizing items
  case edit

  /// Play mode only allows viewing items
  case play
}

/// Manages the state and behavior of a board canvas.
/// Handles mode switching, grid calculations, and item management.
@Observable
final class BoardViewModel {
  // MARK: - Properties

  /// The board being displayed
  private(set) var board: Board

  /// The current mode of the board
  private(set) var mode: BoardMode

  /// The current pan offset of the board view
  private(set) var panOffset: CGPoint

  /// The current zoom scale of the board view
  private(set) var zoomScale: CGFloat

  /// Whether an undo operation is available
  private(set) var canUndo: Bool = false

  /// Whether a redo operation is available
  private(set) var canRedo: Bool = false

  /// Repository for board operations
  private let boardRepository: BoardRepository

  /// Repository for board item operations
  private let boardItemRepository: BoardItemRepository

  /// The size of one grid unit in points
  static let gridUnitSize: CGFloat = 44

  /// The minimum size for board items in grid units
  static let minimumItemSize: CGFloat = 2

  /// The undo stack for tracking changes
  private var undoStack: [BoardItem] = []

  /// The redo stack for tracking undone changes
  private var redoStack: [BoardItem] = []

  // MARK: - Initialization

  /// Creates a new BoardViewModel for managing a board canvas
  /// - Parameters:
  ///   - board: The board to display
  ///   - mode: The initial mode of the board (defaults to .edit)
  ///   - panOffset: The initial pan offset (defaults to .zero)
  ///   - zoomScale: The initial zoom scale (defaults to 1.0)
  ///   - boardRepository: Repository for board operations
  ///   - boardItemRepository: Repository for board item operations
  init(
    board: Board,
    mode: BoardMode = .edit,
    panOffset: CGPoint = .zero,
    zoomScale: CGFloat = 1.0,
    boardRepository: BoardRepository,
    boardItemRepository: BoardItemRepository
  ) {
    self.board = board
    self.mode = mode
    self.panOffset = panOffset
    self.zoomScale = zoomScale
    self.boardRepository = boardRepository
    self.boardItemRepository = boardItemRepository
  }

  // MARK: - Grid Calculations

  /// Converts a point from screen coordinates to grid coordinates
  /// - Parameter point: The point in screen coordinates
  /// - Returns: The point in grid coordinates
  func screenToGrid(_ point: CGPoint) -> CGPoint {
    let gridPoint = CGPoint(
      x: round(point.x / Self.gridUnitSize),
      y: round(point.y / Self.gridUnitSize)
    )
    return gridPoint
  }

  /// Converts a point from grid coordinates to screen coordinates
  /// - Parameter point: The point in grid coordinates
  /// - Returns: The point in screen coordinates
  func gridToScreen(_ point: CGPoint) -> CGPoint {
    let screenPoint = CGPoint(
      x: point.x * Self.gridUnitSize,
      y: point.y * Self.gridUnitSize
    )
    return screenPoint
  }

  /// Snaps a point to the nearest grid corner
  /// - Parameter point: The point to snap
  /// - Returns: The snapped point
  func snapToGrid(_ point: CGPoint) -> CGPoint {
    let gridPoint = screenToGrid(point)
    return gridToScreen(gridPoint)
  }

  // MARK: - Mode Management

  /// Switches the board to edit mode
  func enterEditMode() async throws {
    mode = .edit
    try await saveBoardState()
  }

  /// Switches the board to play mode
  func enterPlayMode() async throws {
    mode = .play
    try await saveBoardState()
    clearUndoRedoStacks()
  }

  // MARK: - State Management

  /// Updates the pan offset and saves it
  /// - Parameter offset: The new pan offset
  func updatePanOffset(_ offset: CGPoint) async throws {
    panOffset = offset
    try await saveBoardState()
  }

  /// Updates the zoom scale and saves it
  /// - Parameter scale: The new zoom scale
  func updateZoomScale(_ scale: CGFloat) async throws {
    zoomScale = scale
    try await saveBoardState()
  }

  /// Saves the current board state to persistent storage
  private func saveBoardState() async throws {
    board = try await boardRepository.updateBoardPanOffset(id: board.id, offset: panOffset)
    board = try await boardRepository.updateBoardZoomScale(id: board.id, scale: zoomScale)
  }

  // MARK: - Item Management

  /// Checks if a size is valid (meets minimum requirements)
  /// - Parameter size: The size to check
  /// - Returns: True if the size is valid
  func isValidSize(_ size: CGSize) -> Bool {
    size.width >= Self.minimumItemSize && size.height >= Self.minimumItemSize
  }

  /// Checks if two items overlap
  /// - Parameters:
  ///   - item1: The first item
  ///   - item2: The second item
  /// - Returns: True if the items overlap
  func itemsOverlap(_ item1: BoardItem, _ item2: BoardItem) -> Bool {
    let item1Rect = CGRect(
      x: item1.position.x,
      y: item1.position.y,
      width: item1.size.width * Self.gridUnitSize,
      height: item1.size.height * Self.gridUnitSize
    )

    let item2Rect = CGRect(
      x: item2.position.x,
      y: item2.position.y,
      width: item2.size.width * Self.gridUnitSize,
      height: item2.size.height * Self.gridUnitSize
    )

    return item1Rect.intersects(item2Rect)
  }

  /// Updates an item's position
  /// - Parameters:
  ///   - itemID: The ID of the item to update
  ///   - position: The new position
  func updateItemPosition(_ itemID: UUID, to position: CGPoint) async throws {
    // TODO: Implement item position updates
  }

  /// Updates an item's size
  /// - Parameters:
  ///   - itemID: The ID of the item to update
  ///   - size: The new size
  func updateItemSize(_ itemID: UUID, to size: CGSize) async throws {
    // TODO: Implement item size updates
  }

  // MARK: - Undo/Redo

  /// Clears the undo and redo stacks
  private func clearUndoRedoStacks() {
    undoStack.removeAll()
    redoStack.removeAll()
    canUndo = false
    canRedo = false
  }

  /// Undoes the last change
  func undo() async throws {
    // TODO: Implement undo
  }

  /// Redoes the last undone change
  func redo() async throws {
    // TODO: Implement redo
  }
}

// MARK: - Preview Support
extension BoardViewModel {
  /// Preview view model for SwiftUI previews
  static let preview = BoardViewModel(
    board: Board.preview,
    boardRepository: BoardMockRepository(),
    boardItemRepository: BoardItemMockRepository()
  )
}
