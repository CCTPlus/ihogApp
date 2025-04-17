import Foundation
import SwiftData

@ModelActor
actor BoardItemSwiftDataRepository: BoardItemRepository {
  func fetchItems(for boardID: UUID) async throws -> [BoardItem] {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate { $0.boardID == boardID }
    )
    let items = try modelContext.fetch(descriptor)
    return items.map { BoardItem(from: $0) }
  }

  func createItem(_ item: BoardItem, boardID: UUID) async throws -> BoardItem {
    let newItemEntity = BoardItemEntity(
      id: item.id,
      boardID: boardID,
      showObjectID: item.showObjectID,
      positionX: item.position.x,
      positionY: item.position.y,
      width: item.size.width,
      height: item.size.height,
      itemType: item.itemType
    )
    modelContext.insert(newItemEntity)
    try modelContext.save()
    return BoardItem(from: newItemEntity)
  }

  func deleteItem(by id: UUID) async throws {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate { $0.id == id }
    )
    guard let itemEntity = try modelContext.fetch(descriptor).first else {
      throw HogError.boardItemNotFound
    }
    modelContext.delete(itemEntity)
    try modelContext.save()
  }

  func deleteItems(for boardID: UUID) async throws {
    let descriptor = FetchDescriptor<BoardItemEntity>(
      predicate: #Predicate { $0.boardID == boardID }
    )
    let items = try modelContext.fetch(descriptor)
    for item in items {
      modelContext.delete(item)
    }
    try modelContext.save()
  }
}
