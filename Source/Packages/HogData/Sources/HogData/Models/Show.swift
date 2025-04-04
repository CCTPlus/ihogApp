//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/1/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright©t 2025 CCT Plus LLC. All rights reserved.
//

import Foundation

public struct Show: Identifiable, Sendable {
  public let id: UUID
  /// Name of SF Symbols
  public var icon: String
  /// Name of show
  public var name: String
  /// The date the show was last opned
  public var dateLastOpened: Date?

  public init(id: UUID, icon: String, name: String, dateLastOpened: Date = .now) {
    self.id = id
    self.icon = icon
    self.name = name
    self.dateLastOpened = dateLastOpened
  }

  init(cdEntity: CDShowEntity) {
    self.id = cdEntity.id ?? UUID()
    self.icon = cdEntity.icon ?? ""
    self.name = cdEntity.name ?? ""
    self.dateLastOpened = cdEntity.dateLastOpened
    // The other properties are not necessary
  }
}

// MARK: - Mock Data
extension Show {
  /// Collection of mock shows for preview purposes
  public static let mockShows: [Show] = [
    Show(
      id: UUID(),
      icon: "folder",
      name: "Summer Festival 2024",
      dateLastOpened: Date().addingTimeInterval(-86400)  // Yesterday
    ),
    Show(
      id: UUID(),
      icon: "folder.fill",
      name: "Circus Show",
      dateLastOpened: Date().addingTimeInterval(-172800)  // 2 days ago
    ),
    Show(
      id: UUID(),
      icon: "folder.badge.plus",
      name: "Theater Production",
      dateLastOpened: Date().addingTimeInterval(-259200)  // 3 days ago
    ),
    Show(
      id: UUID(),
      icon: "folder.circle",
      name: "Symphony Night",
      dateLastOpened: Date().addingTimeInterval(-345600)  // 4 days ago
    ),
    Show(
      id: UUID(),
      icon: "folder.circle.fill",
      name: "Big Top Event",
      dateLastOpened: Date().addingTimeInterval(-432000)  // 5 days ago
    ),
  ]

  /// A single mock show for preview purposes
  public static var mockShow: Show {
    mockShows[0]
  }
}
