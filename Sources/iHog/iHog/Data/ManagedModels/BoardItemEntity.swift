import Foundation
import SwiftData

@Model
final class BoardItemEntity {
  var id: UUID?
  var boardID: UUID?
  var showObjectID: UUID?
  var positionX: Double?
  var positionY: Double?
  var width: Double?
  var height: Double?
  var itemType: BoardItemType?
  var board: BoardEntity?

  init(
    id: UUID? = UUID(),
    boardID: UUID? = nil,
    showObjectID: UUID? = nil,
    positionX: Double? = nil,
    positionY: Double? = nil,
    width: Double? = nil,
    height: Double? = nil,
    itemType: BoardItemType? = .showObject,
    board: BoardEntity? = nil
  ) {
    self.id = id
    self.boardID = boardID
    self.showObjectID = showObjectID
    self.positionX = positionX
    self.positionY = positionY
    self.width = width
    self.height = height
    self.board = board
  }
}

enum BoardItemType: String, Codable {
  case showObject
  case encoder
  case frontPanel
  case playback
}
