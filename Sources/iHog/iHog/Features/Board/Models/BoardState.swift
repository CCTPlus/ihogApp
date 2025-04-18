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

/// Handles all board-specific coordinate system calculations
struct BoardCoordinateSystem {
  /// The size of the viewport
  let viewportSize: CGSize

  /// The current offset of the viewport
  let contentOffset: CGPoint

  /// Converts a point from board coordinates to view coordinates
  func viewPosition(for boardPosition: CGPoint) -> CGPoint {
    CGPoint(
      x: viewportSize.width / 2 + contentOffset.x + boardPosition.x,
      y: viewportSize.height / 2 + contentOffset.y + boardPosition.y
    )
  }

  /// Converts a point from view coordinates to board coordinates
  func boardPosition(for viewPosition: CGPoint) -> CGPoint {
    CGPoint(
      x: viewPosition.x - viewportSize.width / 2 - contentOffset.x,
      y: viewPosition.y - viewportSize.height / 2 - contentOffset.y
    )
  }
}

// MARK: - Coordinate System Extensions

extension CGRect {
  /// The center point of the rectangle
  var center: CGPoint {
    CGPoint(x: minX + width / 2, y: minY + height / 2)
  }

  /// Creates a rectangle from a center point and size
  static func from(center: CGPoint, size: CGSize) -> CGRect {
    CGRect(
      x: center.x - size.width / 2,
      y: center.y - size.height / 2,
      width: size.width,
      height: size.height
    )
  }
}

extension CGPoint {
  /// The position of this point in the board's center-based coordinate system
  var boardPosition: CGPoint {
    self  // Already in center-based coordinates
  }
}
