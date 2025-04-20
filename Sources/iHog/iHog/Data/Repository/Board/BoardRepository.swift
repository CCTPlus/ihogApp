//
//  BoardRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import TelemetryDeck

/// Protocol defining the interface for board operations
/// Provides methods for creating, reading, updating, and deleting boards
protocol BoardRepository {
  /// Creates a new board with the specified name
  /// - Parameters:
  ///   - name: The name for the new board
  ///   - showID: The ID of the show this board belongs to
  /// - Returns: The newly created board
  /// - Throws: An error if the board could not be created
  func createBoard(name: String, showID: UUID) async throws -> Board

  /// Gets all boards for a show, sorted by dateLastModified in descending order
  /// - Parameter showID: The ID of the show to get boards for
  /// - Returns: An array of boards, sorted by dateLastModified (newest first)
  /// - Throws: An error if the boards could not be retrieved
  func getBoards(for showID: UUID) async throws -> [Board]

  /// Deletes a board by its ID
  /// - Parameter id: The ID of the board to delete
  /// - Throws: An error if the board could not be deleted
  func deleteBoard(id: UUID) async throws

  /// Updates a board's name
  /// - Parameters:
  ///   - id: The ID of the board to update
  ///   - name: The new name for the board
  /// - Returns: The updated board
  /// - Throws: An error if the board could not be updated
  func updateBoardName(id: UUID, name: String) async throws -> Board

  /// Updates a board's pan offset
  /// - Parameters:
  ///   - id: The ID of the board to update
  ///   - offset: The new pan offset for the board
  /// - Returns: The updated board
  /// - Throws: An error if the board could not be updated
  func updateBoardPanOffset(id: UUID, offset: CGPoint) async throws -> Board

  /// Updates a board's zoom scale
  /// - Parameters:
  ///   - id: The ID of the board to update
  ///   - scale: The new zoom scale for the board
  /// - Returns: The updated board
  /// - Throws: An error if the board could not be updated
  func updateBoardZoomScale(id: UUID, scale: CGFloat) async throws -> Board
}

/// Errors specific to board operations
enum BoardError: IdentifiableError, Error {
  case notFound
  case showNotFound
  case objectTypeNotFound

  var id: String {
    switch self {
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }
}
