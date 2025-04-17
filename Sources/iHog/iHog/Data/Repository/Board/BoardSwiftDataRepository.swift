import Foundation
import SwiftData

@ModelActor
actor BoardSwiftDataRepository: BoardRepository {
  func createBoard(name: String, showID: UUID) async throws -> Board {
    let newBoardEntity = BoardEntity()
    newBoardEntity.id = UUID()
    newBoardEntity.name = name
    newBoardEntity.showID = showID

    // Get the show entity and establish the relationship
    let showDescriptor = FetchDescriptor<ShowEntity>(predicate: #Predicate { $0.id == showID })
    guard let showEntity = try modelContext.fetch(showDescriptor).first else {
      throw HogError.showNotFound
    }
    newBoardEntity.show = showEntity
    showEntity.boards?.append(newBoardEntity)

    modelContext.insert(newBoardEntity)
    try modelContext.save()
    let createdBoard = Board(from: newBoardEntity)
    HogLogger
      .log(category: .board)
      .debug(
        "Board created with entity ID: \(newBoardEntity.id?.uuidString ?? "No ID") | Non managed ID: \(createdBoard.id.uuidString)"
      )
    notifyCreatedBoard(board: createdBoard)
    return createdBoard
  }

  func getBoard(by id: UUID) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(predicate: #Predicate { $0.id == id })
    guard let board = try modelContext.fetch(descriptor).first else {
      throw HogError.boardNotFoundForID
    }
    return Board(from: board)
  }

  func getAllBoards(for showID: UUID) async throws -> [Board] {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate { $0.showID == showID }
    )
    let boards = try modelContext.fetch(descriptor)
    if boards.isEmpty {
      throw HogError.boardNotFoundForShow
    }
    return boards.map { Board(from: $0) }
  }

  func deleteBoard(by id: UUID) async throws {
    let descriptor = FetchDescriptor<BoardEntity>(predicate: #Predicate { $0.id == id })
    guard let board = try modelContext.fetch(descriptor).first else {
      throw HogError.boardNotFoundForID
    }
    modelContext.delete(board)
    try modelContext.save()
  }

  func deleteAll(for showID: UUID) async throws {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate { $0.showID == showID }
    )
    let boards = try modelContext.fetch(descriptor)
    if boards.isEmpty {
      throw HogError.boardNotFoundForShow
    }
    boards.forEach { modelContext.delete($0) }
    try modelContext.save()
  }

  func getCountOfBoards(for showID: UUID) async throws -> Int {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate { $0.showID == showID }
    )
    return try modelContext.fetchCount(descriptor)
  }

  func updateBoardName(_ name: String, for boardID: UUID) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(predicate: #Predicate { $0.id == boardID })
    guard let boardEntity = try modelContext.fetch(descriptor).first else {
      throw HogError.boardNotFoundForID
    }

    boardEntity.name = name
    try modelContext.save()
    return Board(from: boardEntity)
  }

  func updateBoardPositionAndZoom(
    boardID: UUID,
    lastPanOffset: CGPoint,
    lastZoomScale: Double
  ) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(predicate: #Predicate { $0.id == boardID })
    guard let boardEntity = try modelContext.fetch(descriptor).first else {
      throw HogError.boardNotFoundForID
    }

    boardEntity.lastPanOffsetX = lastPanOffset.x
    boardEntity.lastPanOffsetY = lastPanOffset.y
    boardEntity.lastZoomScale = lastZoomScale

    try modelContext.save()
    return Board(from: boardEntity)
  }
}
