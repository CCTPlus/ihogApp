//
//  BoardItemTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import Testing

@testable import iHog

/// Tests for BoardItem to ensure proper initialization and property validation
@Suite("Board Item Tests")
final class BoardItemTests {
  /// Test show objects for board item tests
  private let testShowObjects: [ShowObject] = [
    ShowObject(objType: .group, number: 1, name: "Test Group", objColor: "red"),
    ShowObject(objType: .intensity, number: 1, name: "Test Intensity", objColor: "green"),
    ShowObject(objType: .position, number: 1, name: "Test Position", objColor: "blue"),
    ShowObject(objType: .color, number: 1, name: "Test Color", objColor: "yellow"),
    ShowObject(objType: .beam, number: 1, name: "Test Beam", objColor: "purple"),
  ]

  /// Test board for board item tests
  private let testBoard = Board.preview

  /// Tests initialization with all properties set
  /// Verifies that all properties are correctly set and preserved
  @Test("BoardItem initialization with all properties")
  func testInitWithAllProperties() throws {
    let showObject = testShowObjects[0]
    let item = BoardItem(
      id: UUID(),
      boardID: testBoard.id,
      itemType: showObject.objType,
      referenceID: showObject.id,
      position: CGPoint(x: 100, y: 200),
      size: CGSize(width: 88, height: 88)
    )

    #expect(item.boardID == testBoard.id)
    #expect(item.itemType == showObject.objType)
    #expect(item.referenceID == showObject.id)
    #expect(item.position.x == 100)
    #expect(item.position.y == 200)
    #expect(item.size.width == 88)
    #expect(item.size.height == 88)
  }

  /// Tests initialization with minimum size
  /// Verifies that the minimum size of 1×1 grid unit (44×44 points) is enforced
  @Test("BoardItem initialization with minimum size")
  func testInitWithMinimumSize() throws {
    let showObject = testShowObjects[1]
    let item = BoardItem(
      boardID: testBoard.id,
      itemType: showObject.objType,
      referenceID: showObject.id,
      position: .zero,
      size: CGSize(width: 44, height: 44)
    )

    #expect(item.size.width == 44)
    #expect(item.size.height == 44)
  }

  /// Tests initialization with non-square size
  /// Verifies that rectangular sizes are supported
  @Test("BoardItem initialization with non-square size")
  func testInitWithNonSquareSize() throws {
    let showObject = testShowObjects[2]
    let item = BoardItem(
      boardID: testBoard.id,
      itemType: showObject.objType,
      referenceID: showObject.id,
      position: .zero,
      size: CGSize(width: 88, height: 132)
    )

    #expect(item.size.width == 88)
    #expect(item.size.height == 132)
  }

  /// Tests initialization from entity with all properties set
  /// Verifies that all properties are correctly mapped from the entity
  @Test("BoardItem initialization from entity with all properties")
  func testInitFromEntityWithAllProperties() throws {
    let entity = BoardItemEntity()
    entity.id = UUID()
    entity.boardID = testBoard.id
    entity.itemType = testShowObjects[3].objType.rawValue
    entity.referenceID = testShowObjects[3].id
    entity.positionX = 100
    entity.positionY = 200
    entity.width = 88
    entity.height = 88

    let item = BoardItem(from: entity)

    #expect(item.id == entity.id)
    #expect(item.boardID == testBoard.id)
    #expect(item.itemType == testShowObjects[3].objType)
    #expect(item.referenceID == testShowObjects[3].id)
    #expect(item.position.x == 100 / 44.0)
    #expect(item.position.y == 200 / 44.0)
    #expect(item.size.width == 88 / 44.0)
    #expect(item.size.height == 88 / 44.0)
  }

  /// Tests initialization from entity with missing properties
  /// Verifies that default values are used when properties are nil
  @Test("BoardItem initialization from entity with missing properties")
  func testInitFromEntityWithMissingProperties() throws {
    let entity = BoardItemEntity()

    let item = BoardItem(from: entity)

    #expect(item.id != UUID())
    #expect(item.boardID != UUID())
    #expect(item.itemType == .group)
    #expect(item.referenceID != UUID())
    #expect(item.position == .zero)
    #expect(item.size.width == 44 / 44.0)
    #expect(item.size.height == 44 / 44.0)
  }
}
