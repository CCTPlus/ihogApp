import CoreGraphics
import Foundation

class BoardMockRepository: BoardRepository {
  var boards: [Board]

  init(boards: [Board] = []) {
    self.boards = boards
  }

  func createBoard(name: String, showID: UUID) async throws -> Board {
    let newBoard = Board(
      id: UUID(),
      name: name,
      showID: showID,
      lastPanOffset: CGPoint.zero,
      lastZoomScale: 1.0
    )
    boards.append(newBoard)
    NotificationCenter.default.post(name: .didSaveBoard, object: newBoard)
    return newBoard
  }

  func getBoard(by id: UUID) async throws -> Board {
    guard let board = boards.first(where: { $0.id == id }) else {
      throw HogError.boardNotFoundForID
    }
    return board
  }

  func getAllBoards(for showID: UUID) async throws -> [Board] {
    let filtered = boards.filter { $0.showID == showID }
    if filtered.isEmpty {
      throw HogError.boardNotFoundForShow
    }
    return filtered
  }

  func deleteBoard(by id: UUID) async throws {
    guard let index = boards.firstIndex(where: { $0.id == id }) else {
      throw HogError.boardNotFoundForID
    }
    boards.remove(at: index)
  }

  func deleteAll(for showID: UUID) async throws {
    let initialCount = boards.count
    boards.removeAll { $0.showID == showID }
    if boards.count == initialCount {
      throw HogError.boardNotFoundForShow
    }
  }

  func getCountOfBoards(for showID: UUID) async throws -> Int {
    return boards.filter { $0.showID == showID }.count
  }
}

extension BoardMockRepository {
  static let previewWithBoards = BoardMockRepository(
    boards: [
      Board(
        name: "Main Board",
        showID: ShowMockRepository.previewWithShows.shows[0].id,,
        lastPanOffset: .zero,
        lastZoomScale: 1.0
      ),
      Board(
        name: "Secondary Board",
        showID: ShowMockRepository.previewWithShows.shows[0].id,
        lastPanOffset: .zero,
        lastZoomScale: 1.0
      ),
    ]
  )
}
