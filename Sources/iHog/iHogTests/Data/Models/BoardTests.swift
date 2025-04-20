//
//  BoardTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation
import Testing

@testable import iHog

@Suite("Board Model Tests")
final class BoardTests {
  @Test("Board initialization with default values")
  func testDefaultInitialization() {
    let showID = UUID()
    let board1 = Board(
      name: "Test Board",
      showID: showID
    )

    let board2 = Board(
      name: "Test Board",
      showID: showID
    )

    #expect(board1.name == "Test Board")
    #expect(board1.lastPanOffset == .zero)
    #expect(board1.lastZoomScale == 1.0)
    #expect(board1.showID == showID)
    #expect(board1.dateLastModified.timeIntervalSinceNow <= 1)
    #expect(board1.id != board2.id)  // Verify different boards get different IDs
  }

  @Test("Board initialization with custom values")
  func testCustomInitialization() {
    let id = UUID()
    let showID = UUID()
    let customBoard = Board(
      id: id,
      name: "Custom Board",
      showID: showID,
      lastPanOffset: CGPoint(x: 100, y: 100),
      lastZoomScale: 2.0,
      dateLastModified: Date(timeIntervalSince1970: 0)
    )

    #expect(customBoard.name == "Custom Board")
    #expect(customBoard.lastPanOffset == CGPoint(x: 100, y: 100))
    #expect(customBoard.lastZoomScale == 2.0)
    #expect(customBoard.showID == showID)
    #expect(customBoard.id == id)  // Verify the provided ID was used
    #expect(customBoard.dateLastModified == Date(timeIntervalSince1970: 0))
  }

  @Test("Board initialization with specific ID")
  func testSpecificIDInitialization() {
    let specificID = UUID()
    let showID = UUID()
    let board = Board(
      id: specificID,
      name: "Specific ID Board",
      showID: showID
    )

    #expect(board.id == specificID)  // Verify the exact same UUID is used
  }

  @Test("Board initialization from entity")
  func testEntityInitialization() {
    let entity = BoardEntity()
    let id = UUID()
    let showID = UUID()
    entity.id = id
    entity.name = "Entity Board"
    entity.showID = showID
    entity.lastPanOffsetX = 50.0
    entity.lastPanOffsetY = 75.0
    entity.lastZoomScale = 1.5
    entity.dateLastModified = Date(timeIntervalSince1970: 0)

    let board = Board(from: entity)

    #expect(board.id == id)  // Verify the entity's ID was preserved
    #expect(board.name == entity.name)
    #expect(board.showID == showID)
    #expect(board.lastPanOffset == CGPoint(x: 50.0, y: 75.0))
    #expect(board.lastZoomScale == 1.5)
    #expect(board.dateLastModified == entity.dateLastModified)
  }

  @Test("Board equality")
  func testEquality() {
    let id = UUID()
    let showID = UUID()
    let date = Date()

    let board1 = Board(
      id: id,
      name: "Test Board",
      showID: showID,
      dateLastModified: date
    )

    let board2 = Board(
      id: id,
      name: "Test Board",
      showID: showID,
      dateLastModified: date
    )

    #expect(board1 == board2)
  }
}
