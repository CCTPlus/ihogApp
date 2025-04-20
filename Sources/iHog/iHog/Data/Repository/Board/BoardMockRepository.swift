//
//  BoardMockRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation

/// Mock implementation of BoardRepository for testing purposes
/// Provides in-memory storage of boards
final class BoardMockRepository: BoardRepository {
  private var boards: [Board]

  init(boards: [Board] = []) {
    self.boards = boards
  }

  func createBoard(name: String, showID: UUID) async throws -> Board {
    let board = Board(
      id: UUID(),
      name: name,
      showID: showID,
      lastPanOffset: .zero,
      lastZoomScale: 1.0,
      dateLastModified: Date()
    )
    boards.append(board)
    return board
  }

  func getBoards(for showID: UUID) async throws -> [Board] {
    return
      boards
      .filter { $0.showID == showID }
      .sorted { $0.dateLastModified > $1.dateLastModified }
  }

  func deleteBoard(id: UUID) async throws {
    guard let index = boards.firstIndex(where: { $0.id == id }) else {
      throw BoardError.notFound
    }
    boards.remove(at: index)
  }

  func updateBoardName(id: UUID, name: String) async throws -> Board {
    guard let index = boards.firstIndex(where: { $0.id == id }) else {
      throw BoardError.notFound
    }

    var board = boards[index]
    board.name = name
    board.dateLastModified = Date()
    boards[index] = board
    return board
  }

  func updateBoardPanOffset(id: UUID, offset: CGPoint) async throws -> Board {
    guard let index = boards.firstIndex(where: { $0.id == id }) else {
      throw BoardError.notFound
    }

    var board = boards[index]
    board.lastPanOffset = offset
    board.dateLastModified = Date()
    boards[index] = board
    return board
  }

  func updateBoardZoomScale(id: UUID, scale: CGFloat) async throws -> Board {
    guard let index = boards.firstIndex(where: { $0.id == id }) else {
      throw BoardError.notFound
    }

    var board = boards[index]
    board.lastZoomScale = scale
    board.dateLastModified = Date()
    boards[index] = board
    return board
  }
}

extension BoardMockRepository {
  /// Preview data for testing and SwiftUI previews
  static let previewWithBoards = BoardMockRepository(
    boards: [
      Board(
        id: UUID(),
        name: "Main Stage",
        showID: ShowMockRepository.previewWithShows.shows[0].id,
        lastPanOffset: .zero,
        lastZoomScale: 1.0,
        dateLastModified: Date()
      ),
      Board(
        id: UUID(),
        name: "Backstage",
        showID: ShowMockRepository.previewWithShows.shows[0].id,
        lastPanOffset: .zero,
        lastZoomScale: 1.0,
        dateLastModified: Date()
      ),
      Board(
        id: UUID(),
        name: "Wings",
        showID: ShowMockRepository.previewWithShows.shows[0].id,
        lastPanOffset: .zero,
        lastZoomScale: 1.0,
        dateLastModified: Date()
      ),
    ]
  )
}
