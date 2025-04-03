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
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import Foundation

public struct Show: Identifiable {
  public let id: UUID
  public var icon: String
  public var name: String
  public var dateLastOpened: Date

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
    self.dateLastOpened = cdEntity.dateLastOpened ?? .now
    // The other properties are not necessary
  }
}
