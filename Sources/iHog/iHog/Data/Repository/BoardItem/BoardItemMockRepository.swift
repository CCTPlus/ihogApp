import Foundation

class BoardItemMockRepository: BoardItemRepository {
  var items: [BoardItem]

  init(items: [BoardItem]) {
    self.items = items
  }

  func fetchItems(for boardID: UUID) async throws -> [BoardItem] {
    return items.filter { $0.boardID == boardID }
  }

  func createItem(_ item: BoardItem, boardID: UUID) async throws -> BoardItem {
    let newItem = BoardItem(
      id: item.id,
      boardID: boardID,
      showObjectID: item.showObjectID,
      position: item.position,
      size: item.size,
      itemType: item.itemType
    )
    items.append(newItem)
    return newItem
  }

  func updateItem(_ item: BoardItem) async throws {
    guard let index = items.firstIndex(where: { $0.id == item.id }) else {
      throw HogError.boardItemNotFound
    }
    items[index] = item
  }

  func deleteItem(by id: UUID) async throws {
    items.removeAll(where: { $0.id == id })
  }

  func deleteItems(for boardID: UUID) async throws {
    items.removeAll(where: { $0.boardID == boardID })
  }
}

extension BoardItemMockRepository {
  static let previewWithItems = BoardItemMockRepository(
    items: [
      BoardItem(
        boardID: BoardMockRepository.previewWithBoards.boards[0].id,
        showObjectID: ShowObjectMockRepository.preview.objects[0].id,
        position: CGPoint(x: -88, y: -88),  // -2 grid units from center
        size: CGSize(width: 88, height: 88),  // 2x2 grid units
        itemType: .showObject
      ),
      BoardItem(
        boardID: BoardMockRepository.previewWithBoards.boards[0].id,
        showObjectID: ShowObjectMockRepository.preview.objects[1].id,
        position: CGPoint(x: 88, y: 88),  // 2 grid units from center
        size: CGSize(width: 88, height: 88 * 2),  // 2x2 grid units
        itemType: .showObject
      ),
    ]
  )
}
