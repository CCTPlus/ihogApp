//
//  BoardSwiftDataRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import Foundation
import SwiftData

/// SwiftData implementation of BoardRepository
/// Manages board data persistence using SwiftData
@ModelActor
actor BoardSwiftDataRepository: BoardRepository {
  func createBoard(name: String, showID: UUID) async throws -> Board {
    let entity = BoardEntity(name: name, showID: showID)
    modelContext.insert(entity)
    try modelContext.save()
    return Board(from: entity)
  }

  func getBoards(for showID: UUID) async throws -> [Board] {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.showID == showID },
      sortBy: [SortDescriptor(\.dateLastModified, order: .reverse)]
    )

    let entities = try modelContext.fetch(descriptor)
    return entities.map { Board(from: $0) }
  }

  func deleteBoard(id: UUID) async throws {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardError.notFound
    }

    modelContext.delete(entity)
    try modelContext.save()
  }

  func updateBoardName(id: UUID, name: String) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardError.notFound
    }

    entity.name = name
    entity.dateLastModified = Date()
    try modelContext.save()

    return Board(from: entity)
  }

  func updateBoardPanOffset(id: UUID, offset: CGPoint) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardError.notFound
    }

    entity.lastPanOffsetX = offset.x
    entity.lastPanOffsetY = offset.y
    entity.dateLastModified = Date()
    try modelContext.save()

    return Board(from: entity)
  }

  func updateBoardZoomScale(id: UUID, scale: CGFloat) async throws -> Board {
    let descriptor = FetchDescriptor<BoardEntity>(
      predicate: #Predicate<BoardEntity> { $0.id == id }
    )

    guard let entity = try modelContext.fetch(descriptor).first else {
      throw BoardError.notFound
    }

    entity.lastZoomScale = scale
    entity.dateLastModified = Date()
    try modelContext.save()

    return Board(from: entity)
  }
}
