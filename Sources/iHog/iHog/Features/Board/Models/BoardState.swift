import CoreGraphics
import Foundation

/// Manages the state of a board, including its viewport position, zoom level, and mode.
/// The board uses a coordinate system where (0,0) is at the center of the viewport.
struct BoardState {
  /// The current zoom level of the board. 1.0 is normal size, higher values zoom in.
  var zoomLevel: Double

  /// The current offset of the viewport from the center (0,0) point.
  /// Positive values move right/down, negative values move left/up.
  var contentOffset: CGPoint

  /// Whether the board is in edit mode (true) or play mode (false).
  /// In edit mode, objects can be moved and resized.
  /// In play mode, objects can only be triggered.
  var isEditMode: Bool

  /// Whether the grid is currently visible.
  /// This is always true in edit mode and false in play mode.
  var isGridVisible: Bool {
    isEditMode
  }

  /// The viewport position when the board was last saved.
  /// Used to restore the exact position when reopening the board.
  var lastSavedOffset: CGPoint?

  /// The zoom level when the board was last saved.
  /// Used to restore the exact zoom when reopening the board.
  var lastSavedZoom: Double?

  init(
    zoomLevel: Double = 1.0,
    contentOffset: CGPoint = .zero,
    isEditMode: Bool = true,
    lastSavedOffset: CGPoint? = nil,
    lastSavedZoom: Double? = nil
  ) {
    self.zoomLevel = zoomLevel
    self.contentOffset = contentOffset
    self.isEditMode = isEditMode
    self.lastSavedOffset = lastSavedOffset
    self.lastSavedZoom = lastSavedZoom
  }
}
