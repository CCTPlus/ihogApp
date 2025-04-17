import CoreGraphics
import Foundation

struct BoardItem: Identifiable, Hashable {
  var id: UUID
  var boardID: UUID
  var showObjectID: UUID
  var itemType: BoardItemType
  var position: CGPoint {
    get {
      CGPoint(x: positionX ?? 0, y: positionY ?? 0)
    }
    set {
      positionX = newValue.x
      positionY = newValue.y
    }
  }
  private var positionX: Double?
  private var positionY: Double?

  var size: CGSize {
    get {
      CGSize(width: width ?? 0, height: height ?? 0)
    }
    set {
      width = newValue.width
      height = newValue.height
    }
  }
  private var width: Double?
  private var height: Double?

  init(
    id: UUID = UUID(),
    boardID: UUID,
    showObjectID: UUID,
    position: CGPoint = .zero,
    size: CGSize = .zero,
    itemType: BoardItemType = .showObject
  ) {
    self.id = id
    self.boardID = boardID
    self.showObjectID = showObjectID
    self.itemType = itemType
    self.position = position
    self.size = size
  }

  init(from entity: BoardItemEntity) {
    self.id = entity.id ?? UUID()
    self.boardID = entity.boardID ?? UUID()
    self.showObjectID = entity.showObjectID ?? UUID()
    self.itemType = entity.itemType ?? .showObject
    self.positionX = entity.positionX
    self.positionY = entity.positionY
    self.width = entity.width
    self.height = entity.height
  }
}
