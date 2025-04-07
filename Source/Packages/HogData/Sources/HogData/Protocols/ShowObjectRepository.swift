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

public protocol ShowObjectRepository: Sendable {
  /// Fetches all show objects belonging to a show
  func getShowObjects(for showID: UUID) async throws -> [ShowObject]
  /// Fetches all show objects for a show with a specific type
  ///
  /// Used to get scenes, lists, palettes, etc
  func getShowObjects(for showID: UUID, of objType: ObjectType) async throws -> [ShowObject]
  func createShowObject(showObject: ShowObject) async throws -> ShowObject
  func deleteShowObject(_ showObject: ShowObject) async throws
}
