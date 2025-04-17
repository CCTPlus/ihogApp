import Foundation
import SwiftData

@Model
final class BoardEntity {
  var id: UUID?
  var name: String?
  var showID: UUID?
  var lastPanOffsetX: Double?
  var lastPanOffsetY: Double?
  var lastZoomScale: Double?

  @Relationship(deleteRule: .cascade, inverse: \BoardItemEntity.board)
  var items: [BoardItemEntity]?

  var show: ShowEntity?

  init(
    id: UUID? = UUID(),
    name: String? = nil,
    showID: UUID? = nil,
    lastPanOffsetX: Double? = 0,
    lastPanOffsetY: Double? = 0,
    lastZoomScale: Double? = 1.0,
    items: [BoardItemEntity]? = [],
    show: ShowEntity? = nil
  ) {
    self.id = id
    self.name = name
    self.showID = showID
    self.lastPanOffsetX = lastPanOffsetX
    self.lastPanOffsetY = lastPanOffsetY
    self.lastZoomScale = lastZoomScale
    self.items = items
    self.show = show
  }
}
