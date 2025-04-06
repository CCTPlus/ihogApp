//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import Foundation

public struct ShowObject: Identifiable, Equatable, Hashable, Sendable {
  public let id: UUID
  public var isOutlined: Bool
  public var name: String
  public var number: Double
  var color: String
  var type: ObjectType
  var showID: UUID

  public init(
    id: UUID,
    isOutlined: Bool,
    name: String,
    number: Double,
    color: String,
    type: ObjectType,
    showID: UUID
  ) {
    self.id = id
    self.isOutlined = isOutlined
    self.name = name
    self.number = number
    self.color = color
    self.type = type
    self.showID = showID
  }

  init(cdEntity: CDShowObjectEntity) {
    guard let objID = cdEntity.id else {
      fatalError("🚨 NO ID GIVEN")
    }
    guard let foundShowID = cdEntity.show?.id else {
      fatalError("🚨 NO ID GIVEN")
    }
    guard let objType = cdEntity.objType else {
      fatalError("🚨 NO TYPE GIVEN")
    }
    self.id = objID
    self.isOutlined = cdEntity.isOutlined
    self.name = cdEntity.name ?? "NO NAME"
    self.number = cdEntity.number
    self.color = cdEntity.objColor ?? ""
    // TODO: 2025-04-05: Need a better default
    self.type = ObjectType(rawValue: objType) ?? .list
    self.showID = foundShowID
  }
}

public enum ObjectType: String, Sendable {
  case group
  case intensity
  case position
  case color = "colour"
  case beam
  case effect

  case list
  case scene
  case batch

  case macro
  case plot
  case page
}

// MOCKS
extension ShowObject {
  /// Collection of mock show objects for testing purposes
  public static let mockShowObjects: [ShowObject] = [
    // Groups (10)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "All Movers",
      number: 1.0,
      color: "red",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Front Lights",
      number: 2.0,
      color: "blue",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Back Lights",
      number: 3.0,
      color: "green",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Side Lights",
      number: 4.0,
      color: "yellow",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Floor Lights",
      number: 5.0,
      color: "purple",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "LED Strips",
      number: 6.0,
      color: "orange",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Spots",
      number: 7.0,
      color: "cyan",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Washes",
      number: 8.0,
      color: "magenta",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Beams",
      number: 9.0,
      color: "pink",
      type: .group,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Audience Lights",
      number: 10.0,
      color: "white",
      type: .group,
      showID: Show.mockShow.id
    ),

    // Lists (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Opening",
      number: 1.0,
      color: "blue",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Act 1",
      number: 2.0,
      color: "red",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Intermission",
      number: 3.0,
      color: "green",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Act 2",
      number: 4.0,
      color: "yellow",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Finale",
      number: 5.0,
      color: "purple",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Encore",
      number: 6.0,
      color: "orange",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "House Lights",
      number: 7.0,
      color: "white",
      type: .list,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Emergency",
      number: 8.0,
      color: "red",
      type: .list,
      showID: Show.mockShow.id
    ),

    // Scenes (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Blackout",
      number: 1.0,
      color: "black",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Full Stage",
      number: 2.0,
      color: "white",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Down Stage",
      number: 3.0,
      color: "blue",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Up Stage",
      number: 4.0,
      color: "red",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Stage Left",
      number: 5.0,
      color: "green",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Stage Right",
      number: 6.0,
      color: "yellow",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Center Spot",
      number: 7.0,
      color: "purple",
      type: .scene,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Full Wash",
      number: 8.0,
      color: "cyan",
      type: .scene,
      showID: Show.mockShow.id
    ),

    // Position Palettes (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Stage Wash",
      number: 1.0,
      color: "blue",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Down Stage Center",
      number: 2.0,
      color: "red",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Up Stage Center",
      number: 3.0,
      color: "green",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Stage Left",
      number: 4.0,
      color: "yellow",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Stage Right",
      number: 5.0,
      color: "purple",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Audience",
      number: 6.0,
      color: "orange",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Band Position",
      number: 7.0,
      color: "cyan",
      type: .position,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Drum Riser",
      number: 8.0,
      color: "magenta",
      type: .position,
      showID: Show.mockShow.id
    ),

    // Color Palettes (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Warm White",
      number: 1.0,
      color: "white",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Cool White",
      number: 2.0,
      color: "gray",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Deep Blue",
      number: 3.0,
      color: "blue",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Red",
      number: 4.0,
      color: "red",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Green",
      number: 5.0,
      color: "green",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Yellow",
      number: 6.0,
      color: "yellow",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Magenta",
      number: 7.0,
      color: "magenta",
      type: .color,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Cyan",
      number: 8.0,
      color: "cyan",
      type: .color,
      showID: Show.mockShow.id
    ),

    // Beam Palettes (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Narrow",
      number: 1.0,
      color: "white",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Wide",
      number: 2.0,
      color: "gray",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Iris In",
      number: 3.0,
      color: "blue",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Iris Out",
      number: 4.0,
      color: "red",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Soft Edge",
      number: 5.0,
      color: "green",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Hard Edge",
      number: 6.0,
      color: "yellow",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Gobo 1",
      number: 7.0,
      color: "purple",
      type: .beam,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Gobo 2",
      number: 8.0,
      color: "orange",
      type: .beam,
      showID: Show.mockShow.id
    ),

    // Effects (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Circle",
      number: 1.0,
      color: "blue",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Square",
      number: 2.0,
      color: "red",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Figure 8",
      number: 3.0,
      color: "green",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Rainbow",
      number: 4.0,
      color: "yellow",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Ballyhoo",
      number: 5.0,
      color: "purple",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Swing",
      number: 6.0,
      color: "orange",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Chase",
      number: 7.0,
      color: "cyan",
      type: .effect,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Pulse",
      number: 8.0,
      color: "magenta",
      type: .effect,
      showID: Show.mockShow.id
    ),

    // Macros (8)
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Lamp On",
      number: 1.0,
      color: "green",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Lamp Off",
      number: 2.0,
      color: "red",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Reset All",
      number: 3.0,
      color: "yellow",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Home All",
      number: 4.0,
      color: "blue",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Fan On",
      number: 5.0,
      color: "purple",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Fan Off",
      number: 6.0,
      color: "orange",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: true,
      name: "Clear All",
      number: 7.0,
      color: "white",
      type: .macro,
      showID: Show.mockShow.id
    ),
    ShowObject(
      id: UUID(),
      isOutlined: false,
      name: "Stop All",
      number: 8.0,
      color: "gray",
      type: .macro,
      showID: Show.mockShow.id
    ),
  ]
}
