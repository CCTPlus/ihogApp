import Foundation
import SwiftData
import SwiftUI

protocol BoardRepository {
  /// Creates a board given the name and show ID
  func createBoard(name: String, showID: UUID) async throws -> Board
  /// Gets board by ID
  func getBoard(by id: UUID) async throws -> Board
  /// Gets all boards for a show
  func getAllBoards(for showID: UUID) async throws -> [Board]
  /// Delete a board for a given ID
  func deleteBoard(by id: UUID) async throws
  /// Deletes all boards for a show
  func deleteAll(for showID: UUID) async throws
  /// Returns the number of boards a show has
  func getCountOfBoards(for showID: UUID) async throws -> Int
  /// Updates an existing board's name
  func updateBoardName(_ name: String, for boardID: UUID) async throws -> Board
  /// Updates an existing board's position and zoom
  func updateBoardPositionAndZoom(
    boardID: UUID,
    lastPanOffset: CGPoint,
    lastZoomScale: Double
  ) async throws -> Board
}

extension BoardRepository {
  func notifyCreatedBoard(board: Board) {
    NotificationCenter.default.post(name: .didSaveBoard, object: board)
  }
}
