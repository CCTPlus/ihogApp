import CoreGraphics
import Foundation

struct Board: Identifiable, Equatable, Codable, Sendable {
  var id: UUID
  var name: String
  var showID: UUID
  var lastPanOffset: CGPoint {
    get {
      CGPoint(x: lastPanOffsetX ?? 0, y: lastPanOffsetY ?? 0)
    }
    set {
      lastPanOffsetX = newValue.x
      lastPanOffsetY = newValue.y
    }
  }
  private var lastPanOffsetX: Double?
  private var lastPanOffsetY: Double?
  var lastZoomScale: Double?

  init(
    id: UUID = UUID(),
    name: String,
    showID: UUID,
    lastPanOffset: CGPoint = .zero,
    lastZoomScale: Double? = 1.0
  ) {
    self.id = id
    self.name = name
    self.showID = showID
    self.lastPanOffset = lastPanOffset
    self.lastZoomScale = lastZoomScale
  }

  init(from entity: BoardEntity) {
    self.id = entity.id ?? UUID()
    self.name = entity.name ?? ""
    self.showID = (entity.show?.id ?? entity.showID) ?? UUID()
    self.lastPanOffsetX = entity.lastPanOffsetX
    self.lastPanOffsetY = entity.lastPanOffsetY
    self.lastZoomScale = entity.lastZoomScale
  }
}
