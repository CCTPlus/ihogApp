import CoreGraphics
import Foundation

struct Board: Identifiable, Equatable, Codable, Sendable {
  var id: UUID
  var name: String
  var showID: UUID

  var lastPanOffset: CGPoint
  var lastZoomScale: Double

  init(
    id: UUID = UUID(),
    name: String,
    showID: UUID,
    lastPanOffset: CGPoint = .zero,
    lastZoomScale: Double = 1.0
  ) {
    self.id = id
    self.name = name
    self.showID = showID
    self.lastZoomScale = lastZoomScale
    self.lastPanOffset = lastPanOffset
  }

  init(from entity: BoardEntity) {
    self.id = entity.id ?? UUID()
    self.name = entity.name ?? ""
    self.showID = (entity.show?.id ?? entity.showID) ?? UUID()
    self.lastPanOffset = CGPoint(
      x: entity.lastPanOffsetX ?? 0.0,
      y: entity.lastPanOffsetY ?? 0.0
    )
    self.lastZoomScale = entity.lastZoomScale ?? 1
  }
}
