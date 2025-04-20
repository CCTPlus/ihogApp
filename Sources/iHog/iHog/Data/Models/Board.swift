//
//  Board.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation

/// Non-managed model representing a board in the show.
/// Used in views and business logic, separate from the managed BoardEntity.
/// Converts between managed and non-managed representations.
struct Board: Identifiable, Equatable, Codable, Sendable {
  /// Unique identifier for the board
  var id: UUID

  /// Display name of the board
  var name: String

  /// Reference to the show this board belongs to
  var showID: UUID

  /// Last pan offset applied to the board view
  var lastPanOffset: CGPoint

  /// Last zoom scale applied to the board view
  var lastZoomScale: CGFloat

  /// Timestamp of the last modification
  var dateLastModified: Date

  /// Creates a new board with default values
  /// - Parameters:
  ///   - id: Unique identifier, defaults to new UUID
  ///   - name: Display name of the board
  ///   - showID: Reference to the show this board belongs to
  ///   - lastPanOffset: Last pan offset, defaults to zero
  ///   - lastZoomScale: Last zoom scale, defaults to 1.0
  ///   - dateLastModified: Last modification date, defaults to now
  init(
    id: UUID = .init(),
    name: String,
    showID: UUID,
    lastPanOffset: CGPoint = .zero,
    lastZoomScale: CGFloat = 1.0,
    dateLastModified: Date = .now
  ) {
    self.id = id
    self.name = name
    self.showID = showID
    self.lastPanOffset = lastPanOffset
    self.lastZoomScale = lastZoomScale
    self.dateLastModified = dateLastModified
  }

  /// Creates a board from a managed BoardEntity
  /// Handles conversion of optional values from managed model
  /// - Parameter entity: The managed BoardEntity to convert from
  init(from entity: BoardEntity) {
    self.id = entity.id ?? UUID()
    self.name = entity.name ?? ""
    self.showID = entity.showID ?? UUID()
    self.lastPanOffset = CGPoint(
      x: entity.lastPanOffsetX ?? 0,
      y: entity.lastPanOffsetY ?? 0
    )
    self.lastZoomScale = CGFloat(entity.lastZoomScale ?? 1.0)
    self.dateLastModified = entity.dateLastModified ?? Date()
  }
}

// MARK: - Preview Data
extension Board {
  /// Preview board for SwiftUI previews
  static let preview = Board(
    name: "Main Board",
    showID: UUID(),
    lastPanOffset: .zero,
    lastZoomScale: 1.0
  )

  /// Array of preview boards for SwiftUI previews
  static let previewBoards = [
    Board(name: "Main Board", showID: UUID()),
    Board(name: "Focus Board", showID: UUID(), lastPanOffset: CGPoint(x: 100, y: 100)),
    Board(name: "Color Board", showID: UUID(), lastZoomScale: 1.5),
  ]
}
