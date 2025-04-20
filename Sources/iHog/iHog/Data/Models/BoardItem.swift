//
//  BoardItem.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//
//

import CoreGraphics
import Foundation

/// Represents an item placed on a board that references a show object.
/// Items are positioned relative to the board's center (0,0) and sized in grid units.
/// Each grid unit is 44×44 points, with a minimum size of 1×1 grid unit.
/// The position and size are used to render the item on the board canvas.
struct BoardItem {
  /// Unique identifier for this board item
  /// Used for tracking and updating specific items
  let id: UUID

  /// Identifier of the board this item belongs to
  /// Required for relationship management and filtering items by board
  var boardID: UUID

  /// Item type of object on the board
  ///
  /// For now this is the same as the ShowObjectType but it will be expanded to include other types like encoderwheels and sliders
  var itemType: ShowObjectType

  /// Links this board item to its source object for data synchronization
  var referenceID: UUID

  /// Position of the item's center relative to the board's center (0,0)
  /// Measured in points, with positive X right and positive Y up
  var position: CGPoint

  /// Size of the item in grid units
  /// Each grid unit is 44×44 points, with a minimum size of 1×1
  var size: CGSize

  /// Creates a new board item with the specified properties
  /// - Parameters:
  ///   - id: Unique identifier for this item
  ///   - boardID: Identifier of the board this item belongs to
  ///   - itemType: Type of the referenced show object
  ///   - referenceID: Identifier of the referenced show object
  ///   - position: Position of the item's center relative to the board's center
  ///   - size: Size of the item in grid units (minimum 1×1)
  init(
    id: UUID = UUID(),
    boardID: UUID,
    itemType: ShowObjectType,
    referenceID: UUID,
    position: CGPoint,
    size: CGSize
  ) {
    self.id = id
    self.boardID = boardID
    self.itemType = itemType
    self.referenceID = referenceID
    self.position = position
    self.size = size
  }

  /// Creates a new board item from a managed entity
  /// Used when loading items from SwiftData storage
  init(from entity: BoardItemEntity) {
    print("Creating BoardItem from entity: \(entity.id?.uuidString ?? "nil")")
    self.id = entity.id ?? UUID()
    self.boardID = entity.boardID ?? UUID()
    self.itemType = ShowObjectType(rawValue: entity.itemType ?? "") ?? .group
    self.referenceID = entity.referenceID ?? UUID()
    self.position = CGPoint(
      x: entity.positionX ?? 0,
      y: entity.positionY ?? 0
    )
    self.size = CGSize(
      width: entity.width ?? 44,
      height: entity.height ?? 44
    )
  }
}

// MARK: - Preview Data
extension BoardItem {
  /// Preview board item for a group at the center of the board
  static let previewGroup = BoardItem(
    boardID: Board.preview.id,
    itemType: .group,
    referenceID: testShowObjects[0].id,
    position: .zero,
    size: CGSize(width: 88, height: 88)
  )

  /// Preview board item for an intensity at the top right
  static let previewIntensity = BoardItem(
    boardID: Board.preview.id,
    itemType: .intensity,
    referenceID: testShowObjects[5].id,
    position: CGPoint(x: 44, y: 44),
    size: CGSize(width: 88, height: 88)
  )

  /// Preview board item for a position at the bottom left
  static let previewPosition = BoardItem(
    boardID: Board.preview.id,
    itemType: .position,
    referenceID: testShowObjects[1].id,
    position: CGPoint(x: -44, y: -44),
    size: CGSize(width: 88, height: 88)
  )

  /// Preview board item for a color at the top left
  static let previewColor = BoardItem(
    boardID: Board.preview.id,
    itemType: .color,
    referenceID: testShowObjects[6].id,
    position: CGPoint(x: -44, y: 44),
    size: CGSize(width: 88, height: 88)
  )

  /// Preview board item for a beam at the bottom right
  static let previewBeam = BoardItem(
    boardID: Board.preview.id,
    itemType: .beam,
    referenceID: testShowObjects[7].id,
    position: CGPoint(x: 44, y: -44),
    size: CGSize(width: 88, height: 88)
  )
}
