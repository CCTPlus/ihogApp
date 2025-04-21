//
//  BoardViewModelTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import Testing

@testable import iHog

/// Tests for the BoardViewModel, verifying its ability to manage board state and operations.
/// Each test focuses on a single behavior to ensure clear test isolation and maintainability.
@Suite("BoardViewModel Tests")
struct BoardViewModelTests {
  /// Verifies that a new view model initializes with correct default values.
  /// This ensures the view model starts in a clean state with proper defaults.
  @Test("Initialization sets correct default values")
  func initialization() async throws {
    let board = Board.preview
    let viewModel = BoardViewModel(
      board: board,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    #expect(viewModel.board == board)
    #expect(viewModel.mode == .edit)
    #expect(viewModel.panOffset == .zero)
    #expect(viewModel.zoomScale == 1.0)
    #expect(viewModel.canUndo == false)
    #expect(viewModel.canRedo == false)
  }

  /// Verifies that initialization with custom values properly sets all properties.
  /// This ensures the view model can be configured with specific initial state.
  @Test("Initialization with custom values")
  func initializationWithCustomValues() async throws {
    let board = Board.preview
    let viewModel = BoardViewModel(
      board: board,
      mode: .play,
      panOffset: CGPoint(x: 100, y: 100),
      zoomScale: 2.0,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    #expect(viewModel.board == board)
    #expect(viewModel.mode == .play)
    #expect(viewModel.panOffset == CGPoint(x: 100, y: 100))
    #expect(viewModel.zoomScale == 2.0)
    #expect(viewModel.canUndo == false)
    #expect(viewModel.canRedo == false)
  }

  /// Verifies that mode switching properly updates the view model's state.
  /// This ensures the view model can transition between edit and play modes.
  @Test("Mode switching")
  func modeSwitching() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    #expect(viewModel.mode == .edit)

    try await viewModel.enterPlayMode()
    #expect(viewModel.mode == .play)

    try await viewModel.enterEditMode()
    #expect(viewModel.mode == .edit)
  }

  /// Verifies that pan offset updates are properly applied and persisted.
  /// This ensures the view model can track and update board position.
  @Test("Pan offset updates")
  func panOffsetUpdates() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    let newOffset = CGPoint(x: 100, y: 100)
    try await viewModel.updatePanOffset(newOffset)
    #expect(viewModel.panOffset == newOffset)
  }

  /// Verifies that zoom scale updates are properly applied and persisted.
  /// This ensures the view model can track and update board zoom level.
  @Test("Zoom scale updates")
  func zoomScaleUpdates() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    let newScale: CGFloat = 2.0
    try await viewModel.updateZoomScale(newScale)
    #expect(viewModel.zoomScale == newScale)
  }

  /// Verifies that grid calculations correctly convert between screen and grid coordinates.
  /// This ensures proper positioning and snapping behavior.
  @Test("Grid calculations")
  func gridCalculations() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    // Test screen to grid conversion
    let screenPoint = CGPoint(x: 44, y: 44)
    let gridPoint = viewModel.screenToGrid(screenPoint)
    #expect(gridPoint == CGPoint(x: 1, y: 1))

    // Test grid to screen conversion
    let backToScreen = viewModel.gridToScreen(gridPoint)
    #expect(backToScreen == screenPoint)

    // Test snapping to grid
    let snappedPoint = viewModel.snapToGrid(CGPoint(x: 50, y: 50))
    #expect(snappedPoint == screenPoint)

    // Test negative coordinates
    let negativeScreenPoint = CGPoint(x: -44, y: -44)
    let negativeGridPoint = viewModel.screenToGrid(negativeScreenPoint)
    #expect(negativeGridPoint == CGPoint(x: -1, y: -1))

    // Test non-grid-aligned points
    let nonAlignedPoint = CGPoint(x: 66, y: 66)
    let snappedNonAligned = viewModel.snapToGrid(nonAlignedPoint)
    #expect(snappedNonAligned == CGPoint(x: 88, y: 88))
  }

  /// Verifies that size validation correctly checks minimum size requirements.
  /// This ensures items cannot be smaller than the minimum allowed size.
  @Test("Size validation")
  func sizeValidation() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    // Test valid sizes
    #expect(viewModel.isValidSize(CGSize(width: 2, height: 2)) == true)
    #expect(viewModel.isValidSize(CGSize(width: 3, height: 2)) == true)
    #expect(viewModel.isValidSize(CGSize(width: 2, height: 3)) == true)

    // Test invalid sizes
    #expect(viewModel.isValidSize(CGSize(width: 1, height: 2)) == false)
    #expect(viewModel.isValidSize(CGSize(width: 2, height: 1)) == false)
    #expect(viewModel.isValidSize(CGSize(width: 1, height: 1)) == false)
  }

  /// Verifies that overlap detection correctly identifies when items overlap.
  /// This ensures items cannot be placed in invalid positions.
  @Test("Overlap detection")
  func overlapDetection() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    // Create test items
    let item1 = BoardItem(
      id: UUID(),
      boardID: UUID(),
      itemType: .group,
      referenceID: UUID(),
      position: CGPoint(x: 0, y: 0),
      size: CGSize(width: 2, height: 2)
    )

    let item2 = BoardItem(
      id: UUID(),
      boardID: UUID(),
      itemType: .group,
      referenceID: UUID(),
      position: CGPoint(x: 1, y: 1),
      size: CGSize(width: 2, height: 2)
    )

    let item3 = BoardItem(
      id: UUID(),
      boardID: UUID(),
      itemType: .group,
      referenceID: UUID(),
      position: CGPoint(x: 3, y: 3),
      size: CGSize(width: 2, height: 2)
    )

    // Test overlapping items
    #expect(viewModel.itemsOverlap(item1, item2) == true)

    // Test non-overlapping items
    #expect(viewModel.itemsOverlap(item1, item3) == false)
    #expect(viewModel.itemsOverlap(item2, item3) == false)
  }

  /// Verifies that undo/redo stacks are cleared when entering play mode.
  /// This ensures history is not maintained between edit sessions.
  @Test("Undo/redo stack clearing")
  func undoRedoStackClearing() async throws {
    let viewModel = BoardViewModel(
      board: Board.preview,
      boardRepository: BoardMockRepository(),
      boardItemRepository: BoardItemMockRepository()
    )

    // Enter play mode to clear stacks
    try await viewModel.enterPlayMode()

    #expect(viewModel.canUndo == false)
    #expect(viewModel.canRedo == false)
  }
}
